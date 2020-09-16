# !usr/bin/python
# -*- coding:utf-8 -*-

import re
import sys
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

def fixed_url(url):
    fixed_url = re.sub("^hxxp", "http", url)
    return fixed_url

def shot(browser, url, name):
    if(browser):
        browser.get(url)
        try:
            print browser.switch_to.alert.text
            browser.switch_to.alert.accept()
        except: 
            print("no alert")
        browser.get_screenshot_as_file(name+'.png')
    else:
        sys.stdout.write(T_LIGHT_RED)
        print("Browser isn't set!")
        sys.stdout.write(NORMAL)

if __name__ == '__main__':
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument('window-size=1200x600')
    browser = webdriver.Chrome(chrome_options=chrome_options, executable_path='/home/ranly/chromedriver')
    
    # print(r)
    # browser.set_page_load_timeout(30)
    # browser.set_script_timeout(30)
        # run(result[1], result[0])
    url = sys.argv[1]
    name = sys.argv[2]
    print(url, name)
        # try:
    shot(browser, url, name)
        # except:
            # print'failed.'
    browser.quit()
