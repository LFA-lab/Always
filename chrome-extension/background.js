// État de l'enregistrement
let recordingState = {
    isRecording: false,
    isPaused: false,
    currentTab: null,
    steps: []
};

// Configuration initiale lors de l'installation
chrome.runtime.onInstalled.addListener(() => {
    console.log('Extension Hyperion Guide installée avec succès');
    
    chrome.storage.local.set({
        isEnabled: true,
        serverUrl: 'http://localhost:3000'
    });
});

// Gestion des messages
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
    switch (message.type) {
        case 'START_RECORDING':
            startRecording();
            break;
            
        case 'STOP_RECORDING':
            stopRecording();
            break;
            
        case 'TOGGLE_PAUSE':
            togglePause(message.isPaused);
            break;
            
        case 'CAPTURE_STEP':
            if (recordingState.isRecording && !recordingState.isPaused) {
                captureStep(message.data);
            }
            break;
    }
    
    return true;
});

// Démarrer l'enregistrement
async function startRecording() {
    try {
        const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
        recordingState.currentTab = tab;
        recordingState.isRecording = true;
        recordingState.steps = [];
        
        // Injecter le script de capture dans l'onglet actif
        await chrome.scripting.executeScript({
            target: { tabId: tab.id },
            files: ['capture.js']
        });
        
        // Activer le side panel
        await chrome.sidePanel.open({ windowId: tab.windowId });
        
        console.log('Enregistrement démarré sur:', tab.url);
    } catch (error) {
        console.error('Erreur lors du démarrage de l\'enregistrement:', error);
    }
}

// Arrêter l'enregistrement
function stopRecording() {
    recordingState.isRecording = false;
    recordingState.isPaused = false;
    recordingState.currentTab = null;
    console.log('Enregistrement arrêté');
}

// Mettre en pause/reprendre l'enregistrement
function togglePause(isPaused) {
    recordingState.isPaused = isPaused;
    console.log('Enregistrement ' + (isPaused ? 'en pause' : 'repris'));
}

// Capturer une étape
async function captureStep(stepData) {
    try {
        // Capturer l'écran
        const screenshot = await chrome.tabs.captureVisibleTab(null, {
            format: 'png'
        });
        
        // Créer l'étape
        const step = {
            ...stepData,
            screenshot,
            timestamp: new Date().toISOString()
        };
        
        // Envoyer l'étape au side panel
        chrome.runtime.sendMessage({
            type: 'NEW_STEP',
            data: step
        });
        
        recordingState.steps.push(step);
        console.log('Étape capturée:', step);
    } catch (error) {
        console.error('Erreur lors de la capture de l\'étape:', error);
    }
}

// Écouter les changements d'onglets
chrome.tabs.onActivated.addListener(async (activeInfo) => {
    if (recordingState.isRecording && !recordingState.isPaused) {
        const tab = await chrome.tabs.get(activeInfo.tabId);
        recordingState.currentTab = tab;
        
        // Injecter le script de capture dans le nouvel onglet
        await chrome.scripting.executeScript({
            target: { tabId: tab.id },
            files: ['capture.js']
        });
    }
});

// Écoute des messages depuis le content script ou le popup
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.type === 'GET_STATUS') {
    chrome.storage.local.get(['isEnabled', 'serverUrl'], (result) => {
      sendResponse({
        isEnabled: result.isEnabled,
        serverUrl: result.serverUrl
      });
    });
    return true; // Indique que la réponse sera asynchrone
  }
});

// Gestionnaire de clic sur l'icône de l'extension
chrome.action.onClicked.addListener(async (tab) => {
    await chrome.sidePanel.open({ windowId: tab.windowId });
});

// Gestionnaire de messages
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
    // Gérer les messages ici si nécessaire
}); 