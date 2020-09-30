---
title: "Webpack: 为Web开发而生的模块管理器"
date: 2014-09-10T20:04:00+08:00
disqus: true
tags: [web]
---

对于开发人员而言，好的包管理器可以让工作事半功倍。现在流行的编程语言大多有自己的[包管理系统](http://blogs.atlassian.com/2014/04/git-project-dependencies/#GitAndProjectDependencies-Firstchoice:useanappropriatebuild/dependencytoolinsteadofgit)。近年来，Web开发越来越火，其开发工具也随之越来越好用了，而[Webpack](http://webpack.github.io)就是一款专为Web开发设计的包管理器。它能够很好地管理、打包Web开发中所用到的HTML、Javascript、CSS以及各种静态文件（图片、字体等），让开发过程更加高效。

### 模块化编程

长久以来，Web开发者都是把所需Javascript、CSS文件一股脑放进HTML里面，对于庞大的项目来说管理起来非常麻烦。[Node.js](http://nodejs.org)的出现改变了这种状态，虽然Javascript的模块并非Node.js发明，但确实是它把这个概念发扬光大了。

但Node.js毕竟是用于服务端的，为了将模块化技术用于浏览器，人们又造出了一大堆工具：[RequireJS](http://requirejs.org)、[Browserify](http://browserify.org)、[LABjs](http://labjs.com)、[Sea.js](http://seajs.org/docs/)、[Duo](http://duojs.org)等。同时，由于Javascript的标准没有对模块的规范进行定义，人们又定义了一系列不同的模块定义：[CommonJS](https://en.wikipedia.org/wiki/CommonJS)、[AMD](https://github.com/amdjs/amdjs-api/wiki/AMD)、[CMD](https://github.com/seajs/seajs/issues/242)、[UMD](https://github.com/umdjs/umd)等。这真是一件令人悲伤的事情，希望ES6 Module的出现能中止这种分裂的状态。

Webpack同时支持CommonJS和AMD形式的模块，对于不支持的模块格式，还支持对模块进行[shimming](http://webpack.github.io/docs/shimming-modules.html)。举个简单的例子：

~~~ javascript
// content.js
module.exports = "It works from content.js.";
~~~~

~~~ javascript
// entry.js
document.write(require("./content.js"));
~~~~

~~~ html
<!-- index.html -->
<html>
  <head>
    <meta charset="utf-8">
  </head>
  <body>
    <script type="text/javascript" src="bundle.js" charset="utf-8"></script>
  </body>
</html>
~~~~

这里`entry.js`是入口文件，它加载了`content.js`。通过命令行对`entry.js`进行编译：

~~~ bash
$ webpack ./entry.js bundle.js
~~~~

打开`index.html`就会看到`content.js`中的内容已经被加载进来了。

Web开发中用到的不但有Javascript，还有CSS以及各种静态文件。Webpack定义了一种叫[加载器loader](http://webpack.github.io/docs/using-loaders.html)的东西，它能够把各种资源文件进行转换，用正确的格式加载到浏览器中。比如对于上述程序，如果我们有一个对应的CSS文件：

~~~ css
/* style.css */
body {
  background: yellow;
}
~~~~

我们修改一下`entry.js`来加载该CSS：

~~~ javascript
require("!style!css!./style.css");
document.write(require("./content.js"));
~~~~

然后再重新编译、打开`index.html`就可以看到CSS加载进来了。执行上述程序前我们必须安装所需的loader：

~~~ bash
npm install --save-dev style-loader css-loader
~~~~

在编译时，css-loader会读取CSS文件，并处理其中的import，返回CSS代码；而style-loader会将返回的CSS代码作为DOM的style。如果你用的是SASS，只要把require语句改成`require("!style!css!sass!./style.scss")`就可以了。

Webpack提供了很多[常见的loader](http://webpack.github.io/docs/list-of-loaders.html)，开发的时候可以把用到的文件都require进来，生成一个单一的Javascript，便于发布。

上述require CSS的代码虽然功能强大，但写起来比较繁琐，Webpack支持在[配置文件中进行配置](http://webpack.github.io/docs/using-loaders.html#configuration)，把符合条件的文件用同一组loader来进行处理。下面是我用的一组loader：

~~~ javascript
{
  module: {
    loaders: [
      {test: /\.coffee$/, loader: 'coffee'},
      {test: /\.html$/,   loader: 'html'},
      {test: /\.json$/,   loader: 'json'},
      {test: /\.css$/,    loader: 'style!css!autoprefixer'},
      {test: /\.scss$/,   loader: 'style!css!autoprefixer!sass'},
      {test: /\.woff$/,   loader: "url?limit=10000&minetype=application/font-woff"},
      {test: /\.ttf$/,    loader: "file"},
      {test: /\.eot$/,    loader: "file"},
      {test: /\.svg$/,    loader: "file"}
    ]
  }
}
~~~~

有了上述配置，直接`require('./style.css')`就可以了，系统会自动先执行[autoprefixer](https://github.com/postcss/autoprefixer)，然后加载CSS，然后再加载为DOM的style。

此外，Webpack还支持[插件](http://webpack.github.io/docs/list-of-plugins.html)，实现对Javascript的压缩、替换等各种操作。

### 依赖模块的管理

Webpack自己并不提供模块的下载，但它可以和已有的包管理器很好的配合。你可以用[npm](http://npmjs.org/)、[Bower](http://bower.io)、[component](https://github.com/componentjs/component)等来管理你的Web开发资源，同时在Webpack中加载它们。

Webpack的文件加载分为三种：

- 绝对路径，比如`require('/home/me/file')`。此时会首先检查目标是否为目录，如果是目录则检查`package.json`的`main`字段（你可以让Webpack同时[检查Bower的字段](http://webpack.github.io/docs/usage-with-bower.html)）；如果没有`package.json`或者没有`main`字段，则会用`index`作为文件名。经过上述过程，我们解析到一个绝对路径的文件名，然后会尝试为其加上扩展名（扩展名可在`webpack.config.js`中设置），第一个存在的文件作为最终的结果。
- 相对路径，比如`require('./file')`。使用当前路径或配置文件中的`context`作为相对路径的目录。加载过程和绝对路径相似。
- 模块路径，如`require('module/lib/file')`。会在配置文件中的所有查找目录中查找。

对于复杂的模块路径，还可以设置别名。一个路径解析配置的例子：

~~~ javascript
{
  resolve: {
    root: [appRoot, nodeRoot, bowerRoot],
    modulesDirectories: [appModuleRoot],
    alias: {
      'angular': 'angular/angular',
      'lodash': 'lodash/dist/lodash'
    },
    extensions: ['', '.js', '.coffee', '.html', '.css', '.scss']
  }
}
~~~~

### 工具的集成

Webpack能够和[grunt](http://webpack.github.io/docs/usage-with-grunt.html)、[gulp](http://webpack.github.io/docs/usage-with-gulp.html)、[karma](http://webpack.github.io/docs/usage-with-karma.html)等已有工具很好地集成。

此外，除了输出单一文件，Webpack还支持[代码分割](http://webpack.github.io/docs/code-splitting.html)、[多入口](http://webpack.github.io/docs/multiple-entry-points.html)以及[运行时模块替换](http://webpack.github.io/docs/hot-module-replacement-with-webpack.html)，是非常值得Web开发者关注的一个工具。

最后附上我的配置文件：

~~~ javascript
// webpack.config.js
var path = require('path');
var webpack = require('webpack');

var appRoot = path.join(__dirname, 'app');
var appModuleRoot = path.join(__dirname, 'app/components');
var bowerRoot = path.join(__dirname, 'bower_components');
var nodeRoot = path.join(__dirname, 'node_modules');

module.exports = {
  entry: 'app',
  output: {
    path: path.resolve('./app/assets'),
    filename: 'bundle.js',
    publicPath: '/assets/'
  },
  resolve: {
    root: [appRoot, nodeRoot, bowerRoot],
    modulesDirectories: [appModuleRoot],
    alias: {
      'angular-ui-tree': 'angular-ui-tree/dist/',
      'angular-date-range-picker': 'angular-date-range-picker/build/'
    },
    extensions: ['', '.js', '.coffee', '.html', '.css', '.scss']
  },
  resolveLoader: {
    root: nodeRoot
  },
  plugins: [
    new webpack.ProvidePlugin({
      _: 'lodash'
    }),
    new webpack.ResolverPlugin([
      new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin("bower.json", ["main"])
    ])
  ],
  module: {
    loaders: [
      {test: /\.coffee$/, loader: 'coffee'},
      {test: /\.html$/,   loader: 'html'},
      {test: /\.json$/,   loader: 'json'},
      {test: /\.css$/,    loader: 'style!css!autoprefixer'},
      {test: /\.scss$/,   loader: 'style!css!autoprefixer!sass'},
      {test: /\.woff$/,   loader: "url?limit=10000&minetype=application/font-woff"},
      {test: /\.ttf$/,    loader: "file"},
      {test: /\.eot$/,    loader: "file"},
      {test: /\.svg$/,    loader: "file"}
    ]
  }
};
~~~~
