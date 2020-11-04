# 참조 사이트: https://velog.io/@ek1816/인스타그램-사당맛집-크롤링

import time
import re
from selenium import webdriver
from bs4 import BeautifulSoup
import pandas as pd


def insta_searching(word):
    url = 'https://www.instagram.com/explore/tags/' + word
    return url


def select_first(driver):
    driver.find_element_by_css_selector('div._9AhH0').click()
    time.sleep(3)


def get_content(driver):
    # 1. 현재 페이지의 HTML 정보 가져오기
    html = driver.page_source
    soup = BeautifulSoup(html, 'lxml')
    # 2. 본문 내용 가져오기
    try:
        content = soup.select('div.C4VMK > span')[0].text

    except:
        content = ' '

    # 3. 본문 내용에서 해시태그 가져오기(정규표현식 활용)
    tags = re.findall(r'#[^\s#,\\]+', content) # content 변수의 본문 내용 중 #으로 시작하며, #뒤에 연속된 문자(공백이나 #, \ 기호가 아닌 경우)를 모두 찾아 tags 변수에 저장
    if len(tags) == 0:
        tags = ''

    # 4. 작성 일자 가져오기
    try:
        date = soup.select('time._1o9PC.Nzb55')[0]['datetime'][:10] #앞에서부터 10자리 글자
    except:
        date = ''
    # 5. 좋아요 수 가져오기
    try:
        like = soup.select('div.Nm9Fw > button')[0].text[4:-1]
        like_kind = 'p'
    except:
        try:
            like = soup.select('body > div._2dDPU.CkGkG > div.zZYga > div > article > div.eo2As > section.EDfFK.ygqzn > div > span')[0].text[3:-1]
            like_kind = 'm'
        except:
            like = 0
            like_kind = 'z'
    # 6. 위치 정보 가져오기
    try:
        place = soup.select('div.JF9hh')[0].text
    except:
        place = ''

    data = [content, date, like_kind, like, place, tags]
    return data


def move_next(driver):
    right = driver.find_element_by_css_selector('a._65Bje.coreSpriteRightPaginationArrow')
    right.click()
    time.sleep(3)


def insta_web_start(driver, url):
    driver.get(url)
    time.sleep(5)


def login_process(driver, id, password):
    login_selector = '#react-root > section > nav > div._8MQSO.Cx7Bp > div > div > div.ctQZg > div > span > a:nth-child(1) > button'

    driver.find_element_by_css_selector(login_selector).click()
    time.sleep(2)

    elem_login = driver.find_element_by_name('username')
    elem_login.clear()
    elem_login.send_keys(id)

    elem_login = driver.find_element_by_name('password')
    elem_login.clear()
    elem_login.send_keys(password)
    time.sleep(1)

    login_selector = '#loginForm > div > div:nth-child(3)'
    driver.find_element_by_css_selector(login_selector).click()
    time.sleep(3)

    after_login_selector = '#react-root > section > main > div > div > div > div > button'
    driver.find_element_by_css_selector(after_login_selector).click()
    time.sleep(2)


def first_bulletin(driver, url):
    driver.get(url)
    time.sleep(4)
    select_first(driver)


def insta_save_csv(insta_df, header=False):
    insta_df.to_csv('insta_bulletin.csv', mode='a', header=header, index=False)


keyword = '서울맛집'
web_driver_file = './chromedriver.exe'

insta_url = insta_searching(keyword)

web_driver = webdriver.Chrome(web_driver_file)
insta_web_start(web_driver, insta_url)
login_process(web_driver, 'wltjd9870@naver.com', 'djzntmxlr6341')

bulletin_df = pd.DataFrame(
            columns=['content', 'date', 'like_kind', 'like', 'place', 'tags'])

insta_save_csv(bulletin_df, header=True)

first_bulletin(web_driver, insta_url)

results = []
target = 10

for i in range(target):
    data = get_content(web_driver)
    results.append(data)
    move_next(web_driver)
    if ((i+1) % 2) == 0:
        print('save')
        bulletin_df = pd.DataFrame(
            data=results,
            columns=['content', 'date', 'like_kind', 'like', 'place', 'tags'])
        insta_save_csv(bulletin_df)
        results = []

print('quit')
