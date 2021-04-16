# FHEM-RCT

FHEM Module based on RCT Client: https://pypi.org/project/rctclient/

**Installation:** 

`update all https://raw.githubusercontent.com/marvin78/FHEM-RCT/master/controls_RCT.txt` 

**Define:**

`define <NAME> RCT <HOST-IP> [<PORT>]`

**Config:**

Poll intervall:

`attr <NAME> pollInterval <seconds>` 

Values for readings:

`attr <NAME> values <values>`

Use the following JSON-Format for `<values>` (see: https://rctclient.readthedocs.io/en/latest/registry.html):

```
{
    "values":[
    {
      "name": "battery.soc", # value name from registry
      "reading": "battery_soc", # individual reading name
      "unit": "%", # unit (will be added to reading)
      "factor": 100, # factor for calculating the readings value
      "intervalFactor": 1, # value is becoming read every x times
      "format": "%.1f" # sprintf format or "date". If "date" is used, the value should be linux timestamp
    },
    ...
    ]
  }
```

Support in FHEM Forums: https://forum.fhem.de/index.php/topic,120219.0.html
