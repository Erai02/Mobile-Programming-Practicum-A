from pathlib import Path
import time
from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parent.parent
SHOTS = ROOT / 'docs' / 'screenshots'
SHOTS.mkdir(exist_ok=True)
CHROME = r'C:\Program Files\Google\Chrome\Application\chrome.exe'
URL = 'http://127.0.0.1:8766'


def enable_semantics(page):
    page.locator('flt-semantics-placeholder').evaluate('(el) => el.click()')
    page.wait_for_timeout(600)


def open_app(browser):
    page = browser.new_page(viewport={'width': 430, 'height': 932}, device_scale_factor=1)
    errors = []
    page.on('console', lambda m: errors.append(m.text) if m.type == 'error' else None)
    page.on('pageerror', lambda e: errors.append(str(e)))
    page.goto(URL, wait_until='load', timeout=90000)
    return page, errors


with sync_playwright() as p:
    browser = p.chromium.launch(executable_path=CHROME, headless=True)

    # Home, search, and detail are one real user flow.
    page, errors = open_app(browser)
    page.wait_for_timeout(10000)
    enable_semantics(page)
    page.screenshot(path=str(SHOTS / 'home.png'))
    print('HOME:', page.locator('body').inner_text()[:500].replace('\n', ' | '))

    search = page.get_by_role('textbox')
    search.fill('Naruto')
    page.get_by_text('Cari', exact=True).click()
    page.wait_for_timeout(7000)
    page.screenshot(path=str(SHOTS / 'search.png'))
    print('SEARCH:', page.locator('body').inner_text()[:700].replace('\n', ' | '))

    page.get_by_text('Naruto 8.0 TV', exact=True).click()
    page.wait_for_timeout(7000)
    page.screenshot(path=str(SHOTS / 'detail.png'))
    print('DETAIL:', page.locator('body').inner_text()[:900].replace('\n', ' | '))
    print('RUNTIME ERRORS:', errors)
    page.close()

    # Delay the API response to capture the real loading state.
    loading, loading_errors = open_app(browser)
    loading.route('https://api.tenrai.org/**', lambda route: None)
    loading.reload(wait_until='load')
    time.sleep(1.2)
    loading.screenshot(path=str(SHOTS / 'loading.png'))
    print('LOADING ERRORS:', loading_errors)
    loading.unroute_all(behavior='ignoreErrors')
    loading.close()

    # Abort the API request to capture the application's real error UI.
    error_page, error_console = open_app(browser)
    error_page.route('https://api.tenrai.org/**', lambda route: route.abort())
    error_page.reload(wait_until='load')
    error_page.wait_for_timeout(5000)
    enable_semantics(error_page)
    error_page.screenshot(path=str(SHOTS / 'error.png'))
    print('ERROR STATE:', error_page.locator('body').inner_text()[:700].replace('\n', ' | '))
    print('ERROR CONSOLE:', error_console)
    error_page.close()

    browser.close()
