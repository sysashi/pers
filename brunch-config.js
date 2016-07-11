exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
        "js/app.js": /^(web\/static\/js)|(node_modules\/)/,
        "js/vendor.js":  /^(web\/static\/vendor)/,
        "admin/js/app.js": /^(web\/static\/admin\/js)|(node_modules\/)/,
        "admin/js/vendor.js": /^(web\/static\/admin\/vendor)/
      }

      // To change the order of concatenation of files, explicitly mention here
      // https://github.com/brunch/brunch/tree/master/docs#concatenation
      // order: {
      //   before: [
      //     "web/static/vendor/js/jquery-2.1.1.js",
      //     "web/static/vendor/js/bootstrap.min.js"
      //   ]
      // }
    },
    stylesheets: {
      joinTo: {
        "css/app.css": /^(web\/static\/css)|(dist\/css)/,
        "admin/css/app.css": /^(web\/static\/admin\/css)|(dist\/css)/
      },
       order: {
         before: ["web/static/css/app.css"] // concat app.css last
       }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(web\/static\/assets)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "web/static",
      "test/static"
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      presets: ['es2015'],
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/, /web\/static\/admin\/vendor/]
    },
    vue: {
      autoprefixer: false,
      postcss: [
        require("postcss-import"),
        require("postcss-cssnext"),
        require("lost")
      ]
    },
    postcss: {
      processors: [
        require("postcss-import"),
        require("postcss-cssnext"),
        require("lost"),
        require("postcss-normalize"),
      ]
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"],
      "admin/js/app.js": ["web/static/admin/js/app"]
    }
  },

  npm: {
    enabled: true
  }
};
