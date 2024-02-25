import { initializeApp } from "https://www.gstatic.com/firebasejs/9.4.0/firebase-app.js";
import { getFirestore, collection, getDocs, doc, deleteDoc, updateDoc } from "https://www.gstatic.com/firebasejs/9.4.0/firebase-firestore.js";

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

async function docDetails() {
    const db = getFirestore(app);
    const docsCollection = collection(db, 'doctors');
    const docsSnapshot = await getDocs(docsCollection);

    const allDocsData = [];

    docsSnapshot.docs.forEach(doc => {
        const data = doc.data();
        allDocsData.push({
            uid: doc.id,
            name: data.name,
            license: data.license,
            status: data.status
        });
    });

    if (allDocsData.length > 0) {
        return allDocsData;
    } else {
        throw new Error('No documents found in the "doctors" collection');
    }
}

// Function to approve doctor and update the status field
async function approveDoctor(uid) {
    console.log('Approving doctor with UID:', uid);
    const db = getFirestore(app);
    const doctorsCollection = collection(db, 'doctors'); // Get reference to the doctors collection
    const doctorRef = doc(doctorsCollection, uid);

    try {
        // Update the status field to "verified" in the doctor document
        await updateDoc(doctorRef, {
            status: "verified"
        });
        console.log('Doctor status updated successfully:', uid);
    } catch (error) {
        console.error('Error updating doctor status:', error);
        alert('Error updating doctor status. Please try again.');
    }
} 


// Function to disapprove doctor and delete the corresponding document and appointments
async function disapproveDoctor(uid) {
    console.log('Disapproving doctor with UID:', uid);
    const db = getFirestore(app);
    const doctorsCollection = collection(db, 'doctors'); // Get reference to the doctors collection
    const doctorRef = doc(doctorsCollection, uid);

    try {
        //Delete all appointments for the doctor from the "appointments" subcollection
        const appointmentsCollection = collection(doctorRef, 'appointments');
        const appointmentsQuerySnapshot = await getDocs(appointmentsCollection);
        
        appointmentsQuerySnapshot.forEach(async appointmentDoc => {
            await deleteDoc(appointmentDoc.ref);
            console.log('Appointment document deleted successfully:', appointmentDoc.id);
        });

        //Delete the doctor document from the "doctors" collection
        await deleteDoc(doctorRef);
        console.log('Doctor document deleted successfully:', uid);

        // Remove the corresponding UI element
        const doctorElement = document.getElementById(`doctor-${uid}`);
        if (doctorElement) {
            doctorElement.remove();
            console.log('Corresponding UI element removed:', uid);
        } else {
            console.log('Corresponding UI element not found:', uid);
        }
    } catch (error) {
        console.error('Error deleting doctor and appointments:', error);
        alert('Error deleting doctor and appointments. Please try again.');
    }
} 


window.onload = async function() {
    try {
        const allDocsData = await docDetails();

        const doctorContainer = document.getElementById('doctorContainer');

        doctorContainer.innerHTML = '';

        allDocsData.forEach(doctor => {
            if(doctor.status == "not verified"){
                const doctorInfoDiv = document.createElement('div');
                doctorInfoDiv.id = `doctor-${doctor.uid}`;
                doctorInfoDiv.classList.add('doctor-info');

                const doctorUidPara = document.createElement('p');
                doctorUidPara.textContent = `Doctor UID: ${doctor.uid}`;
                doctorInfoDiv.appendChild(doctorUidPara);

                const doctorNamePara = document.createElement('p');
                doctorNamePara.textContent = `Name: ${doctor.name}`;
                doctorInfoDiv.appendChild(doctorNamePara);

                const licensePara = document.createElement('p');
                licensePara.textContent = `License: ${doctor.license}`;
                doctorInfoDiv.appendChild(licensePara);

                const approveBtn = document.createElement('button');
                approveBtn.textContent = 'Approve';
                approveBtn.onclick = () => approveDoctor(doctor.uid); // Function to approve doctor
                doctorInfoDiv.appendChild(approveBtn);

                const disapproveBtn = document.createElement('button');
                disapproveBtn.textContent = 'Disapprove';
                disapproveBtn.onclick = () => disapproveDoctor(doctor.uid); // Function to disapprove doctor
                doctorInfoDiv.appendChild(disapproveBtn);

                doctorContainer.appendChild(doctorInfoDiv);
            }
        });
    } catch (error) {
        console.error('Error fetching and displaying doctors:', error);
        alert('Error fetching and displaying doctors. Please try again.');
    }
};
