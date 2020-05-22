import {promises as fs} from "fs";

async function main() {
    try {
        const inputFilePath = process.argv[2];
        const outputFilePath = process.argv[3];
        const inputData = await fs.readFile(inputFilePath);

        await fs.writeFile(outputFilePath, inputData);
    } catch (error) {
        console.error(error.message);

        process.exit(1);
    }
}

main();
