#!/bin/env python3
##################################################
# @author : syomie
# @created : 2022-02-21
##################################################
import re
from json import dump, load
from os import system

import sys
from os import getenv
import time
from urllib.parse import urlparse

if getenv("GITHUB_ACTIONS"):
    TERMUX_ENV = False
else:
    TERMUX_ENV = True


class source_info:
    """源信息"""
    uptime: int
    """更新时间"""
    path: str
    """存储路径(相对路径)"""


RE_18R = re.compile(r"🔞|💃|🤶|💏")
RE_EMOJI = re.compile(r"\s|[🌀-🏿🐀-📰📲-🙏🚀-🛿☀-⭕]")
sources_map: dict = {}


def clear_emoji(instr: str) -> str:
    """清理emoji表情"""
    return RE_EMOJI.sub("", instr)


def rules_split(fp,
                overwrite: bool = False,
                uptime: bool = False,
                nodo: bool = False):
    """分割书源到单个文件"""
    mode = "xt" if not overwrite else "w"
    jsons = load(fp)
    if isinstance(jsons, list):
        for item in jsons:
            # 清理源注释中的检测反馈
            item["bookSourceComment"] = re.sub(r"[eE]rror:.+(\\n|$)*|^(\\n)*",
                                               "", item["bookSourceComment"])

            item["bookSourceName"] = clear_emoji(item["bookSourceName"])
            domain = urlparse(re.sub(r"\s", "", item["bookSourceUrl"])).netloc

            if domain in sources_map.keys():
                old_info = sources_map.get(domain)
                if old_info and old_info.uptime < item["lastUpdateTime"]:
                    print(f"正在更新: {domain}")
                    system(f"rm {old_info.path}")
                else:
                    continue

            # 屏蔽18r源
            if del_18r and re.match(RE_18R, item.get(
                    "bookSourceGroup", "")) or re.match(
                        RE_18R, item["bookSourceName"]):
                print(f'已屏蔽: {item["bookSourceName"]} {domain}')
                continue

            csi = source_info()
            # 文件路径
            csi.path = "share/" + domain + ".json"
            if item.get("bookSourceGroup", False):
                if "鸡肋" in item["bookSourceGroup"] or "失效" in item[
                        "bookSourceGroup"]:
                    csi.path = "not_recommend/" + domain + ".json"

            csi.uptime = item["lastUpdateTime"]
            sources_map[domain] = csi
            if nodo: continue
            try:
                with open(csi.path, mode) as jf:
                    if TERMUX_ENV and not item["bookSourceName"]:
                        system(f'termux-open-url {item["bookSourceUrl"]}')
                        dn = input(f'给{item["bookSourceUrl"]}起个名字：')
                        item["bookSourceName"] = dn
                    if uptime:
                        item["lastUpdateTime"] = round(time.time() * 1000)
                    dump(item, jf, ensure_ascii=False, indent=4)
            except FileExistsError as e:
                print('文件已存在: ', e.filename)


def _help():
    print(" 书源分割工具。")
    print("\t-w 覆盖已有文件")
    print("\t-t 更新修改时间")
    print("\t-nd 不执行实际写入")
    print("\t-nx 不清理特殊分组")
    exit(0)


if __name__ == "__main__":
    overwrite = False
    uptime = False
    nodo = False
    del_18r = True
    argv = sys.argv[1:]
    if "-h" in argv:
        _help()
    if "-w" in argv:
        print("启用书源覆盖")
        overwrite = True
    if "-t" in argv:
        print("更新修改时间")
        uptime = True
    if "-nd" in argv:
        nodo = True
    if "-nx" in argv:
        del_18r = False
    with open("./bookSource.json", "r") as f:
        try:
            rules_split(f, overwrite, uptime, nodo)
        except FileNotFoundError as e:
            print("请在项目根,目录有README.md的地方执行")
    #  print(sources_map)
