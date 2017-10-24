# Website we want to scrape is: https://www.verizonwireless.com/smartphones/samsung-galaxy-s7/
# The documentatio of selenium is here: http://selenium-python.readthedocs.io/index.html

# Please follow the instructions below to setup the environment of selenium
# Step #1
# Windows users: download the chromedriver from here: https://chromedriver.storage.googleapis.com/index.html?path=2.30/
# Mac users: Install homebrew: http://brew.sh/
#			 Then run 'brew install chromedriver' on the terminal
#
# Step #2
# Windows users: open Anaconda prompt and switch to python3 environment. Then run 'conda install -c conda-forge selenium'
# Mac users: open Terminal and switch to python3 environment. Then run 'conda install -c conda-forge selenium'

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import csv

# Windows users need to specify the path to chrome driver you just downloaded.
# You need to unzip the zipfile first and move the .exe file to any folder you want.
# driver = webdriver.Chrome(r'path\to\where\you\download\the\chromedriver.exe')
driver = webdriver.Chrome()

url_list = ["https://stockx.com/adidas-yeezy-boost-350-v2-white-core-black-red", 
			"https://stockx.com/adidas-yeezy-boost-350-v2-cream-white",
			"https://stockx.com/adidas-yeezy-powerphase-calabasas-core-white",
			"https://stockx.com/adidas-yeezy-boost-350-v2-core-black-red-2017",
			"https://stockx.com/adidas-yeezy-boost-350-v2-steeple-grey-beluga-solar-red",
			"https://stockx.com/adidas-yeezy-boost-350-v2-core-black-white",
			"https://stockx.com/adidas-yeezy-boost-350-v2-core-black-red",
			"https://stockx.com/adidas-yeezy-boost-750-chocolate-light-brown-gum",
			"https://stockx.com/adidas-yeezy-boost-350-v2-core-black-copper",
			"https://stockx.com/adidas-yeezy-boost-350-pirate-black-2016",
			"https://stockx.com/adidas-yeezy-boost-350-v2-core-black-green",
			"https://stockx.com/adidas-yeezy-boost-750-light-grey-glow-in-the-dark",
			"https://stockx.com/adidas-yeezy-boost-350-moonrock",
			"https://stockx.com/adidas-yeezy-boost-350-oxford-tan",
			"https://stockx.com/adidas-yeezy-boost-350-pirate-black-2015",
			"https://stockx.com/adidas-yeezy-boost-750-triple-black",
			"https://stockx.com/adidas-yeezy-boost-350-turtledove",
			"https://stockx.com/adidas-yeezy-boost-750-light-brown",
			"https://stockx.com/yeezy-combat-boot-season-4-oil",
			"https://stockx.com/yeezy-season-three-military-boot-rock",
			"https://stockx.com/adidas-yeezy-boost-950-pirate-black",
			"https://stockx.com/yeezy-military-crepe-boot-taupe",
			"https://stockx.com/adidas-yeezy-boost-950-moonrock",
			"https://stockx.com/adidas-yeezy-boost-950-chocolate",
			"https://stockx.com/yeezy-crepe-boot-season-4-oil",
			"https://stockx.com/yeezy-season-three-military-boot-burnt-sienna",
			"https://stockx.com/yeezy-season-three-military-boot-onyx-shade",
			"https://stockx.com/yeezy-crepe-boot-season-4-taupe",
			"https://stockx.com/yeezy-season-three-military-boot-onyx",
			"https://stockx.com/yeezy-military-crepe-boot-oil",
			"https://stockx.com/adidas-yeezy-boost-950-peyote",
			"https://stockx.com/yeezy-combat-boot-season-4-sand"

			]

csv_file = open('stockxScrapedData.csv', 'w')
# Windows users need to open the file using 'wb'
# csv_file = open('reviews.csv', 'wb')
writer = csv.writer(csv_file)
#'name', 'colorway', 'retailPrice', 'releaseDate' get in table before clicking to get selling data.  might be faster to manually add.
writer.writerow(['name','sellingDate','size', 'resellPrice'])
# Page index used to keep track of where we are.
#index = 1
#while True:
def shoePageScraper():
	time.sleep(3)
	name = driver.find_element_by_xpath('//div[@class="col-md-12"]//h1[@class="name"]').text
	button = driver.find_element_by_xpath('//button[@class="btn"]')
	driver.execute_script("arguments[0].click();", button)
	text = driver.find_element_by_xpath('//div[@class="market-history-sales"]/a[@class="all"]')
	driver.execute_script("arguments[0].click();", text)
		#print("Scraping Page number " + str(index))
		#index = index + 1
	sellingdatarows = driver.find_elements_by_xpath('//table[@class="activity-table table table-condensed table-striped "]/tbody//tr')
	# Find all the reviews
	for sellingdatarow in sellingdatarows:
		# Initialize an empty dictionary for each review
		shoes_dict = {}
		# Use Xpath to locate the title, content, username, date.
		# Once you locate the element, you can use 'element.text' to return its string.
		# To get the attribute instead of the text of each element, use 'element.get_attribute()'
		sellingDate = sellingdatarow.find_element_by_xpath('./td[1]').text
		size = sellingdatarow.find_element_by_xpath('./td[3]').text
		resellPrice = sellingdatarow.find_element_by_xpath('./td[4]').text


		shoes_dict['name'] = name
		shoes_dict['sellingDate'] = sellingDate
		shoes_dict['size'] = size
		shoes_dict['resellPrice'] = resellPrice
		writer.writerow(shoes_dict.values())
def shoePageScraper2():
	time.sleep(3)
	name = driver.find_element_by_xpath('//div[@class="col-md-12"]//h1[@class="name"]').text
	text = driver.find_element_by_xpath('//div[@class="market-history-sales"]/a[@class="all"]')
	driver.execute_script("arguments[0].click();", text)
		#print("Scraping Page number " + str(index))
		#index = index + 1
	sellingdatarows = driver.find_elements_by_xpath('//table[@class="activity-table table table-condensed table-striped "]/tbody//tr')
	# Find all the reviews
	for sellingdatarow in sellingdatarows:
		# Initialize an empty dictionary for each review
		shoes_dict = {}
		# Use Xpath to locate the title, content, username, date.
		# Once you locate the element, you can use 'element.text' to return its string.
		# To get the attribute instead of the text of each element, use 'element.get_attribute()'
		sellingDate = sellingdatarow.find_element_by_xpath('./td[1]').text
		size = sellingdatarow.find_element_by_xpath('./td[3]').text
		resellPrice = sellingdatarow.find_element_by_xpath('./td[4]').text


		shoes_dict['name'] = name
		shoes_dict['sellingDate'] = sellingDate
		shoes_dict['size'] = size
		shoes_dict['resellPrice'] = resellPrice
		writer.writerow(shoes_dict.values())

for url in url_list:
	if (url==url_list[0]):
		driver.get(url)
		shoePageScraper()
	else:
		driver.get(url)
		shoePageScraper2()

csv_file.close()
driver.close()
#		break


	# Better solution using Explicit Waits in selenium: http://selenium-python.readthedocs.io/waits.html?highlight=element_to_be_selected#explicit-waits

	# try:
	# 	wait_review = WebDriverWait(driver, 10)
	# 	reviews = wait_review.until(EC.presence_of_all_elements_located((By.XPATH,
	# 								'//ol[@class="bv-content-list bv-content-list-Reviews bv-focusable"]/li')))
	# 	print(index)
	# 	print('review ok')
	# 	# reviews = driver.find_elements_by_xpath('//ol[@class="bv-content-list bv-content-list-Reviews bv-focusable"]/li')
	#
	# 	wait_button = WebDriverWait(driver, 10)
	# 	button = wait_button.until(EC.element_to_be_clickable((By.XPATH,
	# 								'//div[@class="bv-content-list-container"]//span[@class="bv-content-btn-pages-next"]')))
	# 	print('button ok')
	# 	# button = driver.find_element_by_xpath('//span[@class="bv-content-btn-pages-next"]')
	# 	button.click()
	# except Exception as e:
	# 	print(e)
	# 	driver.close()
	# 	break
