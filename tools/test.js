const { spawnSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const TESTS_DIR = path.join(__dirname, "..", ".lune", "tests");

const testFiles = fs
	.readdirSync(TESTS_DIR)
	.filter((file) => file.endsWith(".luau"))
	.sort();

if (testFiles.length === 0) {
	console.error(`No test files found in ${TESTS_DIR}`);
	process.exit(1);
}

let failures = 0;

for (const file of testFiles) {
	const relativePath = path.relative(process.cwd(), path.join(TESTS_DIR, file));
	console.log(`\n--- Running ${relativePath} ---`);
	const result = spawnSync("lune", ["run", relativePath], { stdio: "inherit" });

	if (result.error || result.status !== 0) {
		failures += 1;
		console.error(`--- FAILED: ${relativePath} ---`);
	}
}

console.log(`\n${testFiles.length - failures}/${testFiles.length} test files passed.`);

if (failures > 0) {
	process.exit(1);
}
