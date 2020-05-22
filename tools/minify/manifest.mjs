import {promises as fs} from "fs";

async function main() {
    try {
        const inputFilePath = process.argv[2];
        const outputFilePath = process.argv[3];
        const inputData = await fs.readFile(inputFilePath);
        const inputDataMinified = JSON.stringify(JSON.parse(inputData.toString()), null, 0);

        await fs.writeFile(outputFilePath, inputDataMinified);
    } catch (error) {
        console.error(error);

        process.exit(1);
    }
}

main();
