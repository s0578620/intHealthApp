
from lxml import html

def scrape_content_between_h2_tags(content, start_tag_text, end_tag_text):
    tree = html.fromstring(content)
    
    xpath_expr = f"//h2[text()='{start_tag_text}']/following-sibling::*[following::h2[text()='{end_tag_text}']]"

    extracted_data = tree.xpath(xpath_expr)

    extracted_html = [html.tostring(item, encoding='unicode') for item in extracted_data]

    return ''.join(extracted_html)
