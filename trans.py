import xml.etree.ElementTree as ET
from googletrans import Translator

def translate_xml_values(input_file, output_file):
    # Initialize the translator
    translator = Translator()

    # Parse the XML file
    tree = ET.parse(input_file)
    root = tree.getroot()

    # Iterate over all mxCell elements
    for mxcell in root.iter('mxCell'):
        value = mxcell.get('value')
        if value:
            # Translate the value from Chinese to English
            translated_value = translator.translate(value, src='zh-cn', dest='en').text
            # Update the value attribute
            mxcell.set('value', translated_value)

    # Write the updated XML to a new file
    tree.write(output_file, encoding='utf-8', xml_declaration=True)

# Usage
input_file = 'system.drawio'
output_file = 'output.xml'
translate_xml_values(input_file, output_file)
