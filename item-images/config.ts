import { readFileSync } from 'fs';

const ENV = process.env.ENVIRONMENT || 'prod'
const FILENAME=`${ENV}.env`;

// Try to load environment variables from shared volume
let envConfig = {};
try {
  const envFile = readFileSync(FILENAME, 'utf8');
  
  // Parse the .env file content
  envConfig = envFile.split('\n').reduce((acc, line) => {
    const match = line.match(/^\s*([\w.-]+)\s*=\s*(.*)?\s*$/);
    if (match) {
      const key = match[1];
      let value = match[2] || '';
      // Remove surrounding quotes if they exist
      value = value.replace(/^['"]|['"]$/g, '');
      acc[key] = value;
    }
    return acc;
  }, {});
  
  console.log(`Successfully loaded environment variables from ${FILENAME}`);
} catch (error) {
  console.log(`Could not load environment variables from ${FILENAME}, falling back to process.env`);
  console.log(`Error details: ${error.message}`);
}

// Merge loaded config with process.env, with process.env taking precedence
const getEnv = (key) => {
  return process.env[key] || envConfig[key];
};

export const S3_CONFIG = {
  bucketName: getEnv('S3_BUCKET_NAME'),
};

export const CLOUDFRONT_CONFIG = {
  domain: getEnv('CLOUDFRONT_DOMAIN'),
};

// The text-to-image model and the region it is invoked in. The request body in lib/item-image.ts is the
// Stability AI text-to-image format, which Stable Image Core, Stable Image Ultra and Stable Diffusion 3.5 Large
// share. Amazon Nova Canvas, which this service used before, reached end of life on 2026-09-30.
export const BEDROCK_IMAGE_CONFIG = {
  modelId: getEnv('BEDROCK_IMAGE_MODEL_ID') || 'stability.stable-image-core-v1:1',
  region: getEnv('BEDROCK_IMAGE_REGION') || 'us-west-2',
};

export const REDIS_CONFIG = {
  host: getEnv('REDIS_HOST') || 'localhost',
  port: 6379
};