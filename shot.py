# !usr/bin/python
# -*- coding:utf-8 -*-

import re
import sys
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

# Text color define
T_LIGHT_RED = "\033[1;31m"
NORMAL = "\033[m" 

# Some phish url will be report "hxxp" or "hxxps"
def refinedURL(url):
    refined = re.sub("^hxxp", "http", url)
    return refined

# Setting browser arguments
def initBrowser():
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument('window-size=1200x600')
    return chrome_options

# It will print red text
def printRedStr(str_):
    sys.stdout.write(T_LIGHT_RED)
    print(str_)
    sys.stdout.write(NORMAL)

# Some phish url will be report "hxxp" or "hxxps"
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
        printStr("Browser isn't set!")

def main():
    # Set browser
    chrome_options = initBrowser()
    browser = webdriver.Chrome(executable_path=r"./chromedriver.exe", chrome_options=chrome_options)

    # If need time out
    # browser.set_page_load_timeout(600)
    # browser.set_script_timeout(600)

    url = sys.argv[1]
    name = sys.argv[2]
    print(url, name)
    try:
        shot(browser, url, name)
    except:
        print("Shot fail!")
    browser.quit()

if __name__ == '__main__':
    main()
