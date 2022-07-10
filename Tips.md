# 提示可能的合作者
## 提交源注意事项
以下文件请勿直接修改,
| 文件 | 说明 | 修改方式 |
| --- | --- | --- |
| bookSource.json | 从share目录自动生成的书源文件 | 拷贝源粘贴到not_recommend目录下或参考下方[特殊分组](#特殊分组) |
| not_recommend.json | 从not_recommend目录自动生成的书源文件 | 拷贝源粘贴到share目录下或参考下方[特殊分组](#特殊分组) |
| README.md | 仓库说明文件 | 修改文件模板 bot/README~.md |
> 为方便查找和修改，建议文件名为网站域名.json

## 特殊分组
| 分组包含字 | 存放目录 | 生成书源文件 |
| :--- | :--- | :--- |
| 鸡肋,失效 | not_recommend | not_recommend.json |

# 小工具

##导出源分割
用于分割导出的源到仓库share或not_recommend目录，依赖python
1. 导出书源到yd3目录内(README.md同级)
2. 在README.md所在目录调用bot/rules_split.py
此时，你想分享的书源已经以每个源一个文件的形式存在于share或者not_recommend目录内了
可以复制后在阅读新建源直接粘贴源

<details><summary>自动标签</summary>
[提问](https://github.com/syomie/yd3/issues)正文包含特殊关键字会触发问题标签。
<details><summary>新增</summary>
 - 作http
 - 添加http
 - 新增http
</details>
<details><summary>书源</summary>
 - 书源
</details>
<details><summary>失效</summary>
 - 失效
 - 不能用了
</details>
<details><summary>站点</summary>
</details>
<details><summary>替换</summary>
</details>
</details>

