#!/usr/bin/env node

const spawn = require("child_process").spawn;
const params = ["pathToScript", "run", "-silent"];
spawn("bash", params, {
  stdio: "ignore",
  detached: true,
}).unref();
