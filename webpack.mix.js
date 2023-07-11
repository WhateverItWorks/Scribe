// Docs: https://github.com/JeffreyWay/laravel-mix/tree/master/docs#readme

let mix = require("laravel-mix");
let plugins = [];

let WebpackNotifierPlugin = require("webpack-notifier");
let webpackNotifier = new WebpackNotifierPlugin({
  alwaysNotify: false,
  skipFirstNotification: true,
});
plugins.push(webpackNotifier);

if (mix.inProduction()) {
  let CompressionWepackPlugin = require("compression-webpack-plugin");
  let gzipCompression = new CompressionWepackPlugin({
    compressionOptions: { level: 9 },
    test: /\.js$|\.css$|\.html$|\.svg$/,
  });
  plugins.push(gzipCompression);
}

mix
  .setPublicPath("public")
  .js("src/js/app.js", "js")
  .css("src/css/app.css", "css")
  .options({
    imgLoaderOptions: { enabled: false },
    clearConsole: false,
  })
  .version(["public/assets"])
  .webpackConfig({
    stats: "errors-only",
    plugins: plugins,
    watchOptions: {
      ignored: /node_modules/,
    },
  })
  .disableNotifications();
