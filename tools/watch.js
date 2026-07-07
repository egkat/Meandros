const chokidar = require("chokidar");
const { execSync } = require("child_process");
const os = require("os");

const PLUGINS_FOLDER = `${os.homedir()}/Documents/Roblox/Plugins`;

function build() {
  try {
    execSync(`rojo build plugin.project.json --output "${PLUGINS_FOLDER}/Meandros.rbxm"`);
    console.log("✅ Built");
  } catch (e) {
    console.error("❌ Failed:", e.message);
  }
}

build();

chokidar.watch(["plugin"], { ignoreInitial: true }).on("all", (event, path) => {
  console.log(`🔄 ${path} changed...`);
  build();
});