// Start writing functions
// https://firebase.google.com/docs/functions/typescript

import {onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";

import {TranslationServiceClient} from "@google-cloud/translate";

if (!admin.apps.length) {
  admin.initializeApp();
}


const projectId = process.env.PROJECT_ID;
const location = process.env.LOCATION;


const translationClient = new TranslationServiceClient();

export const onTranslateText = onCall(async (request) => {
  const listId = request.data?.listId;
  const itemId = request.data?.itemId;


  if (!listId || !itemId) {
    throw new Error("Missing parameters: listId and itemId are required.");
  }

  try {

    const docRef = admin.firestore()
      .collection("todoLists")
      .doc(listId)
      .collection("items")
      .doc(itemId);

    const docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      throw new Error(`TODO item not found: itemId=${itemId}`);
    }

    const todoData = docSnapshot.data();
    const originalDescription = todoData?.description;

    if (!originalDescription) {
      throw new Error("No description found in TODO item.");
    }

    // Construct translation request
    const requestPayload = {
      parent: `projects/${projectId}/locations/${location}`,
      contents: [originalDescription],
      mimeType: "text/plain",
      sourceLanguageCode: "es",
      targetLanguageCode: "en",
    };

    logger.info(requestPayload);

    // Call the Google Cloud Translation API
    const [response] = await translationClient.translateText(requestPayload);
   
    const translatedText = response.translations?.[0]?.translatedText || "";

    // Update Firestore with the translated text
    await docRef.update({
      translation: translatedText,
    });

    logger.info(`Translation saved: ${translatedText}`);

    return {
      message: "Translation completed",
      translatedText: translatedText,
    };
  } catch (error) {
    logger.error(`Translation error: ${error}`);
    throw new Error("Failed to translate TODO description.");
  }
});


