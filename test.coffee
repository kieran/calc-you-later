puppeteer = require 'puppeteer'
{ expect } = require 'chai'

browser = null

before ->
  browser = await puppeteer.launch headless: false, timeout: 10000#, slowMo: 100

after ->
  browser.close()

type = (page, chars='')->
  await page.keyboard.press c for c in chars

assert_output = (page, input='', output='')->
  await type page, input
  text = await page.$eval '.screen', (e)-> e.textContent
  expect(text).to.equal output

describe 'Calculator', ->

  page = null

  before ->
    page = await browser.newPage()
    await page.goto 'http://localhost:1234'

  after ->
    await page.close()

  beforeEach ->
    await page.waitForSelector '.screen'
    await type page, 'c'

  it 'display defaults to 0', ->
    text = await page.$eval '.screen', (e)-> e.textContent
    expect(text).to.equal '0'

  it 'takes key inputs', ->
    assert_output page, '1', '1'

  it 'takes key inputs with decimals', ->
    assert_output page, '1.2', '1.2'

  it 'displays the first input', ->
    assert_output page, '123', '123'

  it 'displays the first input, even after an operation key', ->
    assert_output page, '123+', '123'

  it 'displays the second input after the right hand-side is entered', ->
    assert_output page, '123+456', '456'

  it 'performs addition', ->
    assert_output page, '1+1=', '2'

  it 'performs subtraction', ->
    assert_output page, '4-1=', '3'

  it 'performs multiplication', ->
    assert_output page, '5*5=', '25'

  it 'performs division', ->
    assert_output page, '20/5=', '4'

  it 'inverts the input', ->
    assert_output page, '5i', '-5'

  it 'calculates a percentage', ->
    assert_output page, '5%', '0.05'

  it 'performs a series of calculations', ->
    assert_output page, '1+2-+3/4*5i-65%=', '-8.15'
