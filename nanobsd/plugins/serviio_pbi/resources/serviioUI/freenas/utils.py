from subprocess import Popen, PIPE
import os
import platform

serviio_pbi_path = "/usr/pbi/serviio-" + platform.machine()
serviio_etc_path = os.path.join(serviio_pbi_path, "etc")
serviio_mnt_path = os.path.join(serviio_pbi_path, "mnt")
serviio_fcgi_pidfile = "/var/run/serviio.pid"
serviio_fcgi_wwwdir = os.path.join(serviio_pbi_path, "www")
serviio_control = "/usr/local/etc/rc.d/serviio"
serviio_config = os.path.join(serviio_etc_path, "mt-daapd.conf")
serviio_icon = os.path.join(serviio_pbi_path, "default.png")
serviio_oauth_file = os.path.join(serviio_pbi_path, ".oauth")


def get_rpc_url(request):
    return 'http%s://%s:%s/plugins/json-rpc/v1/' % (
        's' if request.is_secure() else '',
        request.META.get("SERVER_ADDR"),
        request.META.get("SERVER_PORT"),
        )


def get_serviio_oauth_creds():
    f = open(serviio_oauth_file)
    lines = f.readlines()
    f.close()

    key = secret = None
    for l in lines:
        l = l.strip()

        if l.startswith("key"):
            pair = l.split("=")
            if len(pair) > 1:
                key = pair[1].strip()

        elif l.startswith("secret"):
            pair = l.split("=")
            if len(pair) > 1:
                secret = pair[1].strip()

    return key, secret


serviio_advanced_vars = {
    "set_cwd": {
        "type": "checkbox",
        "on": "-a",
        },
    "debuglevel": {
        "type": "textbox",
        "opt": "-d",
        },
    "debug_modules": {
        "type": "textbox",
        "opt": "-D",
        },
    "disable_mdns": {
        "type": "checkbox",
        "on": "-m",
        },
    "non_root_user": {
        "type": "checkbox",
        "on": "-y",
        },
    "ffid": {
        "type": "textbox",
        "opt": "-b",
        },
}
