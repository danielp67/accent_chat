/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */


import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

admin.initializeApp();

export const onConversationsCreated = functions.firestore.
  document("Conversations/{conversationID}").
  onCreate((snapshot: functions.firestore.QueryDocumentSnapshot,
    context: functions.EventContext<{ conversationID: string; }>) => {
    const data = snapshot.data();
    const conversationID = context.params.conversationID;

    if (data) {
      const members = data.members;
      for (let index = 0; index < members.length; index++) {
        const currentUserID = members[index];
        const remainingUserIDs = members
          .filter((u: string) => u !== currentUserID);
        remainingUserIDs.forEach((m: string) => {
          return admin.firestore().collection("Users")
            .doc(m).get().then((_doc) => {
              const userData = _doc.data();
              if (userData) {
                return admin.firestore().collection("Users")
                  .doc(currentUserID).collection("Conversations")
                  .doc(m).create({
                    "chatID": conversationID,
                    "image": userData.image,
                    "name": userData.name,
                    "unseenCount": 1,
                  });
              }
              return null;
            }).catch(() => {
              return null;
            });
        });
      }
    }
    return null;
  });
