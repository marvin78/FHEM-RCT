# FHEM-RCT

FHEM Module based on RCT Client: https://github.com/svalouch/python-rctclient

**Installation:** 

`update all https://raw.githubusercontent.com/marvin78/FHEM-RCT/master/controls_RCT.txt` 

**Define:**

`define <NAME> RCT <HOST-IP> [<PORT>]`

**Config:**

Poll intervall:

`attr <NAME> pollInterval <seconds>` 

Values for readings:

`attr <NAME> values <values>`

`<values>` has to be in JSON-Format:

```
{
    "values":[
    {
      "name": "battery.soc", # Wert aus Registry
      "reading": "battery_soc", # gewünschter Readingname
      "unit": "%", # Einheit (noch ohne Funktion)
      "factor": 100, # Faktor für den gelesenen Wert
      "intervalFactor": 1, # wie oft soll der Wert gelesen werden (hier jedes mal) / 10 würde bedeuten, jedes 10. mal.
      "format": "%.1f"
    },
    ...
    ]
  }
```

Support in FHEM Forums: https://forum.fhem.de/index.php/topic,120219.0.html
