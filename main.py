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
        "dir" : "windows",
        "ext": "bat"
    }
]

def main():
    
    for os in SCRIPTS:
        with open(join(os["dir"], 'protect.' + os['ext'])) as file:
            text = file.read()
            for level in ["high", "low"]:
                generate_file(level, text, os["dir"], os["ext"])

def process_text(text: str, level: str):
    return text.replace("{{primary-dns}}", DNS[level]['primary-dns']).replace("{{secondary-dns}}", DNS[level]['secondary-dns']).replace("{{doh}}", DNS[level]['doh'])

def generate_file(level: str, text: str, dir: str, ext: str):
    with open(join(dir, f"{level}.{ext}"), 'w') as file:
        file.write(process_text(text, level))

    
if __name__=="__main__":
    main()