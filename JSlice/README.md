# 使用方法

1. 安装依赖
```shell
npm install
```
2. 修改`slice.js`文件中的分析对象，形如：
```javascript
const code = fs.readFileSync('testfiles/processBoxShadow.js', 'utf8'); // 被分析的文件路径
const targetLineNumber = 129; // 替换为您的目标行号
const outputFullCallGraph = false; // 设置为true则输出整个文件的CFG图，否则只输出能够执行到目标行的CFG图
```
3. 运行
```shell
node slice.js
```
4. 查看输出
   - 输出会以markdown中mermaid流程图的形式输出在命令行，可以拷贝到任意markdown编辑器中或者使用[mermaid live editor](https://mermaid-js.github.io/mermaid-live-editor/)进行渲染和查看。
   - 被切片的文件会以`out.js`的形式输出在当前目录下。
