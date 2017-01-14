# Sensu-Plugins-Coinbase

A sensu/nagios style check to query the coinbase market API and alert if the price drops below or goes above a certain price

## Usage

You'll need a gdax account with API access. You can get this stuff from here: https://www.gdax.com/settings/api

Once generated, you'll need to specify a low and high value, like so:

```
check_coinbase.rb -k <api_key> -p <api_key_pass> -s <api_key_secret> -l 600 -h 800 -P BTC-USD
```

This will return a result of the buying coin price is below 600 or above 800:

```
CheckCoinbasePrice CRITICAL: Current bitcoin price is $835.88
```

## Security

Obviously there are some very sensitive keys passed to the check. I suggest:

  - Any API key you generate has "View" permissions only.
  - You make sensu of sensu redaction to remove the keys from the command line. I wrote a tutorial about this [here](https://leebriggs.co.uk/sensu/2016/01/27/using-sensu-redaction.html)

