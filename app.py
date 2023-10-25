from os import environ, path
import paramiko
import math
import re
import tempfile
import os


def get_env_variable(name, default=None):
    return environ.get(name, default)


def convert_to_seconds(s):
    seconds_per_unit = {"s": 1, "m": 60, "h": 3600, "d": 86400, "w": 604800, "M": 86400 * 30}
    pattern_seconds_per_unit = re.compile(r'^(' + "|".join(['\\d+' + k for k in seconds_per_unit.keys()]) + ')$')
    if s is None:
        return 30
    if isinstance(s, str):
        return int(s[:-1]) * seconds_per_unit[s[-1]] if pattern_seconds_per_unit.search(s) else 30
    if (isinstance(s, int) or isinstance(s, float)) and not math.isnan(s):
        return round(s)
    return 30


def concatenate_commands(commands):
    command_str = ""
    add_and = False
    for command_line in commands:
        if command_line.endswith('\\'):
            command_str += command_line[:-1]
            add_and = True
        else:
            if add_and:
                command_str += ' && '
                add_and = False
            command_str += command_line
    return command_str


def ssh_process():
    INPUT_HOST = get_env_variable("INPUT_HOST")
    INPUT_PORT = int(get_env_variable("INPUT_PORT", "22"))
    INPUT_USER = get_env_variable("INPUT_USER")
    INPUT_PASS = get_env_variable("INPUT_PASS")
    INPUT_KEY = get_env_variable("INPUT_KEY")
    INPUT_CONNECT_TIMEOUT = get_env_variable("INPUT_CONNECT_TIMEOUT", "30s")
    INPUT_SCRIPT = get_env_variable("INPUT_SCRIPT")

    if INPUT_SCRIPT is None or INPUT_SCRIPT == "" or (INPUT_KEY is None and INPUT_PASS is None):
        print("SSH invalid (Script/Key/Passwd)")
        return

    print("+++++++++++++++++++ RUNNING deploy +++++++++++++++++++")

    commands = [c.strip() for c in INPUT_SCRIPT.splitlines() if c is not None]
    command_str = concatenate_commands(commands)
    print(command_str)

    with paramiko.SSHClient() as ssh:
        tmp = tempfile.NamedTemporaryFile(delete=False)
        try:
            p_key = None
            if INPUT_KEY:
                tmp.write(INPUT_KEY.encode())
                tmp.close()
                p_key = paramiko.RSAKey.from_private_key_file(filename=tmp.name)
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(INPUT_HOST, port=INPUT_PORT, username=INPUT_USER,
                        pkey=p_key, password=INPUT_PASS,
                        timeout=convert_to_seconds(INPUT_CONNECT_TIMEOUT))

            stdin, stdout, stderr = ssh.exec_command(command_str)
            out = "".join(stdout.readlines())
            out = out.strip() if out is not None else None
            if out:
                print(f"Success: \n{out}")

            err = "".join(stderr.readlines())
            err = err.strip() if err is not None else None
            if err:
                if out is None:
                    raise Exception(err)
                else:
                    print(f"Error: \n{err}")
        finally:
            os.unlink(tmp.name)
            tmp.close()


if __name__ == '__main__':
    ssh_process()