from os import listdir
from os.path import isdir, join

DNS = {
    "high": {
        "primary-dns" : "15.184.147.40",
        "secondary-dns": "15.184.182.221",
        "doh": "high-dns.mafazaa.com"
    },
     "low": {
        "primary-dns" : "16.24.111.209",
        "secondary-dns": "16.24.202.94",
        "doh": "low-dns.mafazaa.com"
    }
}

SCRIPTS = [
    {
        "os" : "windows",
        "script_name": "protect",
        "ext": "bat"
    },
    {
        "os": "windows",
        "script_name": "enable-youtube",
        "ext": "bat"
    }
]

def main():
    
    for script in SCRIPTS:
        with open(join(script["os"], script['script_name'] + '.' + script['ext'])) as file:
            text = file.read()
            for level in ["high", "low"]:
                generate_file(level, text, script)

def process_text(text: str, level: str):
    return text.replace("{{primary-dns}}", DNS[level]['primary-dns']).replace("{{secondary-dns}}", DNS[level]['secondary-dns']).replace("{{doh}}", DNS[level]['doh'])

def generate_file(level: str, text: str, script: str):
    with open(join(script['os'], f"{script['script_name']}-{level}.{script['ext']}"), 'w') as file:
        file.write(process_text(text, level))

    
if __name__=="__main__":
    main()