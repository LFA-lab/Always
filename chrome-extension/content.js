// Variables globales
let isEnabled = true;
let serverUrl = 'http://localhost:3000';

// Initialisation
chrome.runtime.sendMessage({ type: 'GET_STATUS' }, (response) => {
  if (response) {
    isEnabled = response.isEnabled;
    serverUrl = response.serverUrl;
    console.log('Extension status:', { isEnabled, serverUrl });
  }
});

// Fonction pour envoyer les données au serveur
async function sendToServer(data) {
  try {
    const response = await fetch(`${serverUrl}/api/interactions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    });
    return await response.json();
  } catch (error) {
    console.error('Erreur lors de l\'envoi des données:', error);
    return null;
  }
}

// Écouteur d'événements pour les clics
document.addEventListener('click', async (event) => {
  if (!isEnabled) return;

  const target = event.target;
  const data = {
    timestamp: new Date().toISOString(),
    elementType: target.tagName,
    elementId: target.id || '',
    elementClass: target.className || '',
    url: window.location.href
  };

  console.log('Interaction détectée:', data);
  await sendToServer(data);
});

// Écoute des messages du background script
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.type === 'UPDATE_STATUS') {
    isEnabled = request.isEnabled;
    serverUrl = request.serverUrl;
    console.log('Status mis à jour:', { isEnabled, serverUrl });
  }
  sendResponse({ success: true });
}); 