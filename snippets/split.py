import os

def split_j2_file(input_path, output_dir, delimiter='==='):
    # Check if input file exists
    if not os.path.exists(input_path):
        print(f"File '{input_path}' not found.")
        return
    
    # Read contents of the file
    with open(input_path, 'r') as f:
        content = f.read()
    
    # Split content by the delimiter
    sections = content.split(delimiter)
    
    # Handle cases with 0 or 1 sections
    if len(sections) <= 1:
        print("No delimiter found or only one section found, nothing to split.")
        return
    
    # Clear output directory if it exists, otherwise create it
    if os.path.exists(output_dir):
        # Remove all files in the output directory
        for file in os.listdir(output_dir):
            file_path = os.path.join(output_dir, file)
            if os.path.isfile(file_path):
                os.remove(file_path)
    else:
        os.makedirs(output_dir, exist_ok=True)
    
    # Write each section to a separate .j2 file in the specified output directory
    for i, section in enumerate(sections, start=1):
        output_file = os.path.join(output_dir, f'part{i}.j2')
        with open(output_file, 'w') as f:
            f.write(section.strip())  # Remove any extra whitespace around sections
        print(f"Created: {output_file}")

# Usage
input_path = '/home/ion/snippets/index.j2.all'      
output_dir = '/home/ion/snippets/open'
split_j2_file(input_path, output_dir)

