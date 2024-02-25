// Import Firebase modules
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.4.0/firebase-app.js";
import { getFirestore, collection, getDocs } from "https://www.gstatic.com/firebasejs/9.4.0/firebase-firestore.js";

// Initialize Firebase app with your Firebase config
const firebaseConfig = {
  apiKey: "AIzaSyCizotJr3gVyDQvixCb65UUTjce6bdPPeE",
  authDomain: "medic-79a9e.firebaseapp.com",
  databaseURL: "https://medic-79a9e-default-rtdb.firebaseio.com",
  projectId: "medic-79a9e",
  storageBucket: "medic-79a9e.appspot.com",
  messagingSenderId: "298383141375",
  appId: "1:298383141375:web:d61fa14305c8f5ddfedfca",
  measurementId: "G-18WCMZHDEZ"
};
const app = initializeApp(firebaseConfig);

async function fetchAdminCredentials() {
    const db = getFirestore(app);
    const adminCollection = collection(db, 'admin');
    const adminSnapshot = await getDocs(adminCollection);

    const adminDoc = adminSnapshot.docs[0];

    if (adminDoc.exists()) {
        const data = adminDoc.data();
        return {
            username: data.username,
            password: data.password
        };
    } else {
        throw new Error('Admin credentials not found in Firestore');
    }
}

document.getElementById('login-form').addEventListener('submit', async function(event) {
    event.preventDefault();

    try {
        const adminCredentials = await fetchAdminCredentials();

        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;

        if (username === adminCredentials.username && password === adminCredentials.password) {
            window.location.href = 'dashboard.html';
        } else {
            alert('Invalid username or password');
        }
    } catch (error) {
        console.error('Error fetching admin credentials:', error);
        alert('Admin credentials not found or error fetching credentials');
    }
});
