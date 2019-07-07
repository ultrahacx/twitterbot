from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import os
import time
os.system('cls')

print ('''
            ==========================================================================================================
            
            $$$$$$$$\ $$\      $$\ $$$$$$\ $$$$$$$$\ $$$$$$$$\ $$$$$$$$\ $$$$$$$\        $$$$$$$\   $$$$$$\ $$$$$$$$\ 
            \__$$  __|$$ | $\  $$ |\_$$  _|\__$$  __|\__$$  __|$$  _____|$$  __$$\       $$  __$$\ $$  __$$\\__$$  __|
               $$ |   $$ |$$$\ $$ |  $$ |     $$ |      $$ |   $$ |      $$ |  $$ |      $$ |  $$ |$$ /  $$ |  $$ |   
               $$ |   $$ $$ $$\$$ |  $$ |     $$ |      $$ |   $$$$$\    $$$$$$$  |      $$$$$$$\ |$$ |  $$ |  $$ |   
               $$ |   $$$$  _$$$$ |  $$ |     $$ |      $$ |   $$  __|   $$  __$$<       $$  __$$\ $$ |  $$ |  $$ |   
               $$ |   $$$  / \$$$ |  $$ |     $$ |      $$ |   $$ |      $$ |  $$ |      $$ |  $$ |$$ |  $$ |  $$ |   
               $$ |   $$  /   \$$ |$$$$$$\    $$ |      $$ |   $$$$$$$$\ $$ |  $$ |      $$$$$$$  | $$$$$$  |  $$ |   
               \__|   \__/     \__|\______|   \__|      \__|   \________|\__|  \__|      \_______/  \______/   \__|   
                                                                                                          
                                                                                                          
            ===========================================================================================================
                                                                                                              
                                     ------------------------------------------                                                                         
                                     |         CREATED BY  ULTRAHACX          |                                           
                                     ------------------------------------------
''')
print(" ")

class Bot:
    def __init__(self,uname,password):
        self.uname = uname
        self.password = password
        self.bot = webdriver.Firefox()

    def login(self):
        bot = self.bot
        bot.get('https://www.twitter.com')
        time.sleep(5)
        email = bot.find_element_by_class_name('email-input')
        password = bot.find_element_by_name('session[password]')
        email.clear()
        password.clear()
        email.send_keys(self.uname)
        password.send_keys(self.password)
        password.send_keys(Keys.RETURN)
        time.sleep(5)
    def liker(self,hash):
        bot = self.bot
        bot.get('https://twitter.com/search?q=' + hash+'&src=typd')
        time.sleep(2)
        for i in range(1,3):
            bot.execute_script('window.scrollTo(0,document.body.scrollHeight)')
            time.sleep(2)
            tweets = bot.find_elements_by_class_name('tweet')
            links = [elem.get_attribute('data-permalink-path') for elem in tweets]
            for link in links:
                bot.get('https://twitter.com'+ link)
                try:
                    bot.find_element_by_class_name('HeartAnimation').click()
                    time.sleep(5)
                except Exception as ex:
                    time.sleep(40)
            print(links)

enterid = input('Enter the Twitter Email ID: ')
enterpass = input('Enter the password of the above account: ')
botstart = Bot(enterid,enterpass)
botstart.login()
enterterm = input('Enter the WORD of which you would like the post: ')
botstart.liker(enterterm)
