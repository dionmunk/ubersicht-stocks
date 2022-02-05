# This is a simple stock ticker that uses the Yahoo! Finance API to get stock data
# Columns are: Ticker, Market Price, Market Change, Market Change %

# Go to http://finance.yahoo.com/ and get the ticker symbols for your stocks
# Put them as a comma separated list below.
symbolList='AAPL,GOOGL,MSFT,BTC-USD,DOGE-USD,ETH-USD'

command: "curl -s 'https://query2.finance.yahoo.com/v7/finance/quote?symbols=#{symbolList}'"

# This link will show you the JSON output from the API
# https://query2.finance.yahoo.com/v7/finance/quote?symbols=AAPL

# How often to refresh the ticker (15s = 15 seconds, 15m = 15 minutes, etc.)
refreshFrequency: '15m'

# Styles for the ticker
style: """
    // position widget
    top 10px
    left 340px

    // text settings
    color #fff
    font-family Helvetica Neue
    background rgba(#000, .15)
    padding 10px 10px
    border-radius 10px

    .container
        width: 300px
        text-align: widget-align
        position: relative
        clear: both

    .widget-title
        text-align: widget-align
        font-size 10px
        text-transform uppercase
        font-weight bold
        margin-bottom: 3px
        text-shadow: 0 1px 0px rgba(#000, .7)

    table
        border-collapse: collapse

    td
        font-size: 12px
        font-weight: 300
        text-shadow: 0 1px 0px rgba(#000, .7)

    .ticker
        color: white
        width: 25%

    .marketprice
        text-align: right

    .change
        text-align: right
        width: 19%

    .change-percent
        text-align: right
        width: 17%

    img
        padding-left: 3px

    .green
        color: #b5d93f

    .red
        color: #df5077
"""

render: (output) -> """
    <div class="container">
        <div class="widget-title">Stocks</div>
        <table id="stocks" width="100%"></table>
    </div>
"""

update: (output) ->
    financeQuoteData = JSON.parse(output)
    financeQuoteResults = financeQuoteData.quoteResponse.result
    
    inner = ""
    
    for i in [0...financeQuoteResults.length]
        symbol = financeQuoteResults[i].symbol
        regularMarketPrice = financeQuoteResults[i].regularMarketPrice.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') # add commas to numbers
        regularMarketChange = financeQuoteResults[i].regularMarketChange.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') # add commas to numbers
        regularMarketChangePercent = financeQuoteResults[i].regularMarketChangePercent.toFixed(2)

        if regularMarketChange > 0
            changeType = 'green';
            arrowType = 'up';
        else 
            changeType = 'red';
            arrowType = 'down';

        inner += "
            <tr>
                <td class='ticker'>#{symbol}</td>
                <td class='marketprice'>#{regularMarketPrice}</td>
                <td class='change #{changeType}'>#{regularMarketChange}</td>
                <td class='change-percent #{changeType}'>#{regularMarketChangePercent}<img src='./stocks.widget/images/#{arrowType}.png'></td>
            </tr>
        "

    $("#stocks").html(inner)
