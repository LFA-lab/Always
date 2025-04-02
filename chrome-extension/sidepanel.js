// État local
let steps = [];
let guide = null;
let isRecording = false;
let isPaused = false;
let isSaving = false;

// Configuration
const API_URL = 'http://localhost:3000/api/v1';
console.log('🔧 Configuration API:', API_URL);

// Initialisation des éléments DOM
let startButton, pauseButton, saveButton, stepsContainer, notification;

// Fonction d'initialisation
function initializeDOMElements() {
    console.log('🔍 Initialisation des éléments DOM...');
    
    startButton = document.getElementById('startCapture');
    pauseButton = document.getElementById('pauseCapture');
    saveButton = document.getElementById('saveGuide');
    stepsContainer = document.getElementById('stepsContainer');
    notification = document.getElementById('notification');
    
    // Vérifier que tous les éléments sont présents
    const elements = { startButton, pauseButton, saveButton, stepsContainer, notification };
    Object.entries(elements).forEach(([name, element]) => {
        if (!element) {
            console.error(`❌ Élément manquant: ${name}`);
        } else {
            console.log(`✅ Élément trouvé: ${name}`);
        }
    });
    
    // Ajouter les écouteurs d'événements
    if (startButton) {
        startButton.addEventListener('click', startCapture);
        console.log('✅ Écouteur ajouté: startCapture');
    }
    
    if (pauseButton) {
        pauseButton.addEventListener('click', togglePause);
        console.log('✅ Écouteur ajouté: togglePause');
    }
    
    if (saveButton) {
        saveButton.addEventListener('click', handleSaveClick);
        console.log('✅ Écouteur ajouté: handleSaveClick');
    }
}

// Gestionnaire de clic pour la sauvegarde
function handleSaveClick(event) {
    console.log('🖱️ Clic sur le bouton de sauvegarde');
    event.preventDefault();
    
    if (!steps.length) {
        console.log('⚠️ Aucune étape à sauvegarder');
        showNotification('Veuillez capturer au moins une étape avant de sauvegarder', true);
        return;
    }
    
    if (isSaving) {
        console.log('⚠️ Sauvegarde déjà en cours');
        return;
    }
    
    // Désactiver le bouton immédiatement
    if (saveButton) {
        console.log('🔒 Désactivation du bouton de sauvegarde');
        saveButton.disabled = true;
        saveButton.innerHTML = '<span class="loading"></span> Sauvegarde en cours...';
    }
    
    // Lancer la sauvegarde
    saveGuide().catch(error => {
        console.error('❌ Erreur lors de la sauvegarde:', error);
        showNotification('Erreur lors de la sauvegarde du guide', true);
        
        // Réactiver le bouton en cas d'erreur
        if (saveButton) {
            console.log('🔓 Réactivation du bouton de sauvegarde');
            saveButton.disabled = false;
            saveButton.innerHTML = '<span class="icon">💾</span> Sauvegarder le Guide';
        }
    });
}

// Démarrer la capture
async function startCapture() {
    console.log('🎥 Démarrage de la capture...');
    try {
        // Envoyer le message au background script
        chrome.runtime.sendMessage({ type: 'START_RECORDING' });
        
        // Mettre à jour l'interface
        isRecording = true;
        isPaused = false;
        updateButtonStates();
        clearSteps();
        
        // Afficher le message de démarrage
        showEmptyState('Capture en cours... Cliquez sur des éléments de la page pour créer des étapes.');
        console.log('✅ Capture démarrée avec succès');
    } catch (error) {
        console.error('❌ Erreur lors du démarrage de la capture:', error);
        showNotification('Impossible de démarrer la capture', true);
    }
}

// Mettre en pause/reprendre la capture
function togglePause() {
    if (!pauseButton) return;
    
    console.log(`${isPaused ? '▶️' : '⏸️'} ${isPaused ? 'Reprise' : 'Pause'} de la capture...`);
    isPaused = !isPaused;
    
    chrome.runtime.sendMessage({ 
        type: 'TOGGLE_PAUSE',
        isPaused 
    });
    
    updateButtonStates();
    
    // Mettre à jour le message d'état
    const message = isPaused 
        ? 'Capture en pause. Cliquez sur "Reprendre" pour continuer.'
        : 'Capture en cours... Cliquez sur des éléments de la page pour créer des étapes.';
    
    showEmptyState(message);
}

// Sauvegarder le guide
async function saveGuide() {
    console.log('💾 Démarrage de la sauvegarde du guide...');
    isSaving = true;

    try {
        // Préparer les données du guide
        const guideData = {
            title: document.getElementById('guideTitle').value || 'Guide sans titre',
            content: steps.map(step => step.description).join('\n\n'),
            url: window.location.href,
            screenshots: steps.map(step => step.screenshot)
        };

        // Envoyer au backend via l'API
        const response = await fetch('https://always-mvp.herokuapp.com/api/guides', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ guide: guideData }),
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const result = await response.json();
        console.log('✅ Guide sauvegardé avec succès:', result);
        
        // Réinitialiser l'interface
        clearSteps();
        showNotification('Guide sauvegardé avec succès !', false);
        
    } catch (error) {
        console.error('❌ Erreur lors de la sauvegarde:', error);
        throw error;
    } finally {
        isSaving = false;
        updateSaveButtonState(false);
    }
}

// Mettre à jour l'état des boutons
function updateButtonStates() {
    if (startButton) {
        startButton.disabled = isRecording;
    }
    
    if (pauseButton) {
        pauseButton.disabled = !isRecording;
        pauseButton.textContent = isPaused ? 'Reprendre' : 'Pause';
        const icon = pauseButton.querySelector('.icon');
        if (icon) {
            icon.textContent = isPaused ? '▶️' : '⏸️';
        }
    }
    
    updateSaveButtonState(isSaving);
}

// Mettre à jour l'état du bouton de sauvegarde
function updateSaveButtonState(loading) {
    if (!saveButton) return;
    
    saveButton.disabled = loading || steps.length === 0;
    saveButton.innerHTML = loading
        ? '<span class="loading"></span> Sauvegarde en cours...'
        : '<span class="icon">💾</span> Sauvegarder le Guide';
}

// Ajouter une nouvelle étape
function addStep(stepData) {
    console.log("📝 Ajout d'une nouvelle étape...");
    const stepNumber = steps.length + 1;
    steps.push(stepData);
    
    const stepElement = createStepElement(stepData, stepNumber);
    
    if (steps.length === 1) {
        stepsContainer.innerHTML = '';
    }
    
    stepsContainer.appendChild(stepElement);
    stepElement.scrollIntoView({ behavior: 'smooth' });
    
    // Activer le bouton de sauvegarde si la capture est arrêtée
    if (!isRecording) {
        saveButton.disabled = false;
    }
    
    console.log(`✅ Étape ${stepNumber} ajoutée avec succès`);
}

// Créer l'élément DOM pour une étape
function createStepElement(stepData, number) {
    const stepElement = document.createElement('div');
    stepElement.className = 'step';
    
    const header = document.createElement('div');
    header.className = 'step-header';
    
    const stepNumber = document.createElement('div');
    stepNumber.className = 'step-number';
    stepNumber.textContent = `Étape ${number}`;
    
    const timestamp = document.createElement('div');
    timestamp.className = 'step-timestamp';
    timestamp.textContent = new Date(stepData.timestamp).toLocaleTimeString();
    
    header.appendChild(stepNumber);
    header.appendChild(timestamp);
    
    const screenshot = document.createElement('img');
    screenshot.className = 'step-screenshot';
    screenshot.src = stepData.screenshot;
    screenshot.alt = `Capture d'écran de l'étape ${number}`;
    
    const details = document.createElement('div');
    details.className = 'step-details';
    details.textContent = `Clic sur ${stepData.element.tagName.toLowerCase()}` + 
        (stepData.element.text ? ` contenant "${stepData.element.text}"` : '');
    
    stepElement.appendChild(header);
    stepElement.appendChild(screenshot);
    stepElement.appendChild(details);
    
    return stepElement;
}

// Afficher un message d'état vide
function showEmptyState(message) {
    if (!stepsContainer) return;
    
    console.log('📝 Affichage du message:', message);
    stepsContainer.innerHTML = `
        <div class="empty-state">
            ${message}
        </div>
    `;
}

// Afficher une notification
function showNotification(message, isError = false) {
    if (!notification) return;
    
    console.log(`${isError ? '❌' : '✅'} Notification:`, message);
    notification.textContent = message;
    notification.className = `notification ${isError ? 'error' : ''}`;
    notification.classList.add('show');
    
    setTimeout(() => {
        notification.classList.remove('show');
    }, 3000);
}

// Vider la liste des étapes
function clearSteps() {
    steps = [];
    showEmptyState('Capture en cours... Cliquez sur des éléments de la page pour créer des étapes.');
}

// Écouter les messages du background script
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
    if (message.type === 'NEW_STEP') {
        addStep(message.data);
    }
});

// Initialiser les éléments DOM après le chargement de la page
document.addEventListener('DOMContentLoaded', () => {
    console.log('🚀 Chargement du panneau latéral...');
    initializeDOMElements();
}); 