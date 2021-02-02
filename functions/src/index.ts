import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendNotificationsHttp = functions.https.onRequest(
    async (req, res) => {
        await sendNotifications();

        res.end();
    }
);

export const sendNotificationsScheduler = functions.pubsub
    .schedule("6 * * * *")
    .timeZone("America/New_York")
    .onRun(async (context) => {
        await sendNotifications();

        return null;
    });

const message = async () => {
    const messages: string[] = [];

    await db
        .collection("messages")
        .get()
        .then((snapshot) => {
            snapshot.forEach((document) => {
                messages.push(document.get("message"));
            });
        });

    return messages[Math.floor(Math.random() * messages.length)];
};

const sendNotifications = async () => {
    let payload: admin.messaging.MessagingPayload | undefined = undefined;

    const body = await message();

    payload = {
        notification: {
            title: "You're Beautiful",
            body,
        },
    };

    if (payload) {
        fcm.sendToTopic("all", payload);
    }
};

export const getMessageOfTheDayHttp = functions.https.onRequest(
    async (req, res) => {
        const body = await message();

        res.send(body);
    }
);
