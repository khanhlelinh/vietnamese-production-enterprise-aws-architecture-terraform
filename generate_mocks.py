import os
import re
from playwright.sync_api import sync_playwright

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
<script src="https://cdn.tailwindcss.com"></script>
<style>
  body { font-family: "Amazon Ember", "Helvetica Neue", Roboto, Arial, sans-serif; background-color: #f2f3f3; }
  .aws-nav { background-color: #232f3e; color: white; }
  .aws-orange { background-color: #ff9900; }
</style>
</head>
<body class="w-[1024px] h-[768px] overflow-hidden">
  <!-- Top Nav -->
  <div class="aws-nav h-12 flex items-center px-4 text-sm font-semibold shadow-md">
    <div class="flex items-center space-x-4">
      <div class="text-xl font-bold text-[#ff9900]">AWS</div>
      <div class="bg-white/20 px-2 py-1 rounded text-gray-200 w-64">Search services, features, blogs, docs</div>
    </div>
    <div class="flex-grow"></div>
    <div class="flex items-center space-x-6 text-gray-300">
      <div class="flex items-center"><span class="ml-1">Singapore (ap-southeast-1)</span></div>
      <div>admin@vpe</div>
    </div>
  </div>

  <div class="flex h-[720px]">
    <!-- Left Sidebar -->
    <div class="w-56 bg-white border-r border-gray-200 shadow-sm flex flex-col p-4">
      <div class="font-bold text-gray-700 mb-4">{SERVICE_NAME}</div>
      <div class="text-sm text-gray-600 space-y-3">
        <div class="font-semibold text-blue-600">Dashboard</div>
        <div>Resources</div>
        <div>Settings</div>
        <div>Monitoring</div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="flex-1 p-8 bg-[#f2f3f3] overflow-y-auto">
      <div class="text-sm text-gray-500 mb-2">{SERVICE_NAME} &gt; {TITLE}</div>
      <h1 class="text-3xl font-bold text-gray-900 mb-6">{TITLE}</h1>

      <div class="bg-white rounded-lg border border-gray-200 shadow-sm p-6 mb-6">
        <h2 class="text-lg font-bold border-b pb-2 mb-4">Configuration Details</h2>
        <p class="text-sm text-gray-600 mb-6">AWS Console setup for Vietnamese Production Enterprise (VPE).</p>
        
        <div class="space-y-5">
           <div class="w-1/2">
             <label class="block text-sm font-medium text-gray-700 mb-1">Resource Name / Identifier</label>
             <input type="text" class="w-full border border-gray-300 rounded px-3 py-2 text-sm" value="vpe-resource" readonly>
           </div>
           
           <div class="flex space-x-6 pt-2">
              <div class="flex items-center"><input type="radio" checked class="mr-2"><span class="text-sm">Standard (Recommended for VPE)</span></div>
              <div class="flex items-center"><input type="radio" class="mr-2"><span class="text-sm text-gray-500">Advanced configuration</span></div>
           </div>
           
           <div class="w-1/2 pt-2">
             <label class="block text-sm font-medium text-gray-700 mb-1">Tags (1)</label>
             <div class="flex items-center space-x-2">
                 <input type="text" class="border border-gray-300 rounded px-3 py-1 text-sm w-32 bg-gray-50" value="Project" readonly>
                 <input type="text" class="border border-gray-300 rounded px-3 py-1 text-sm w-48 bg-gray-50" value="VPE" readonly>
             </div>
           </div>
        </div>
      </div>

      <div class="flex justify-end space-x-4">
        <button class="px-4 py-1.5 border border-gray-300 rounded bg-white text-gray-700 text-sm font-semibold shadow-sm hover:bg-gray-50">Cancel</button>
        <button class="px-4 py-1.5 rounded aws-orange text-black text-sm font-bold shadow-sm hover:bg-orange-400">Create</button>
      </div>
    </div>
  </div>
</body>
</html>
"""

def extract_images_from_docs(docs_dir):
    pattern = re.compile(r'!\[(.*?)\]\((images/.*?\.png)\)')
    images = []
    for filename in os.listdir(docs_dir):
        if filename.endswith(".md"):
            filepath = os.path.join(docs_dir, filename)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
                matches = pattern.findall(content)
                images.extend(matches)
    return images

def generate_screenshots():
    docs_dir = r"D:\Projects\AWS\Japfa\vpe-aws-terraform\docs"
    images_dir = os.path.join(docs_dir, "images")
    os.makedirs(images_dir, exist_ok=True)
    
    image_tasks = extract_images_from_docs(docs_dir)
    print(f"Found {len(image_tasks)} images to generate.")
    
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page(viewport={'width': 1024, 'height': 768})
        
        for alt_text, img_path in image_tasks:
            # Replace ? and other bad chars from alt_text that previous model mangled
            title = alt_text.replace("?", "e").strip()
            if not title:
                title = "Create Resource"
            
            service_name = "AWS Service"
            if "VPC" in title or "Subnet" in title or "Gateway" in title or "Route" in title:
                service_name = "VPC"
            elif "EC2" in title or "Key Pair" in title:
                service_name = "EC2"
            elif "RDS" in title or "Aurora" in title:
                service_name = "RDS"
            elif "S3" in title:
                service_name = "S3"
            elif "IoT" in title:
                service_name = "IoT Core"
            elif "SageMaker" in title:
                service_name = "Amazon SageMaker"
            elif "EKS" in title or "Fargate" in title:
                service_name = "EKS"
            elif "ECR" in title:
                service_name = "ECR"
            elif "API Gateway" in title:
                service_name = "API Gateway"
            
            html = HTML_TEMPLATE.replace("{TITLE}", title).replace("{SERVICE_NAME}", service_name)
            
            # Use set_content to load the html
            page.set_content(html, wait_until="networkidle")
            
            output_path = os.path.join(docs_dir, img_path)
            # Ensure subdirectory exists
            os.makedirs(os.path.dirname(output_path), exist_ok=True)
            
            page.screenshot(path=output_path)
            print(f"Generated: {output_path}")
            
        browser.close()

if __name__ == "__main__":
    generate_screenshots()
