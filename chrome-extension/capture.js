// Configuration
const config = {
    isRecording: false,
    isPaused: false,
    debounceDelay: 500, // Délai en ms pour le debounce des événements
    ignoredElements: ['html', 'body', 'script', 'style', 'meta', 'link']
};

// Initialisation
function initialize() {
    // Écouter les messages du background script
    chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
        switch (message.type) {
            case 'START_CAPTURE':
                startCapture();
                break;
                
            case 'STOP_CAPTURE':
                stopCapture();
                break;
                
            case 'TOGGLE_PAUSE':
                togglePause(message.isPaused);
                break;
        }
    });
}

// Démarrer la capture
function startCapture() {
    config.isRecording = true;
    addEventListeners();
    console.log('Capture démarrée');
}

// Arrêter la capture
function stopCapture() {
    config.isRecording = false;
    removeEventListeners();
    console.log('Capture arrêtée');
}

// Mettre en pause/reprendre la capture
function togglePause(isPaused) {
    config.isPaused = isPaused;
    console.log('Capture ' + (isPaused ? 'en pause' : 'reprise'));
}

// Ajouter les écouteurs d'événements
function addEventListeners() {
    document.addEventListener('click', handleClick, true);
    document.addEventListener('input', debounce(handleInput, config.debounceDelay), true);
    document.addEventListener('change', handleChange, true);
}

// Retirer les écouteurs d'événements
function removeEventListeners() {
    document.removeEventListener('click', handleClick, true);
    document.removeEventListener('input', handleInput, true);
    document.removeEventListener('change', handleChange, true);
}

// Gestionnaire de clic
function handleClick(event) {
    if (!shouldCaptureEvent(event)) return;
    
    const target = event.target;
    const stepData = {
        type: 'click',
        element: {
            tagName: target.tagName.toLowerCase(),
            id: target.id,
            className: target.className,
            textContent: target.textContent?.trim().substring(0, 100),
            value: target.value,
            href: target.href,
            src: target.src,
            alt: target.alt,
            title: target.title,
            placeholder: target.placeholder,
            type: target.type
        },
        path: getElementPath(target),
        url: window.location.href,
        timestamp: new Date().toISOString()
    };
    
    // Générer une description automatique
    stepData.description = generateDescription(stepData);
    
    // Envoyer l'étape au background script
    chrome.runtime.sendMessage({
        type: 'CAPTURE_STEP',
        data: stepData
    });
}

// Gestionnaire de saisie
function handleInput(event) {
    if (!shouldCaptureEvent(event)) return;
    
    const target = event.target;
    if (target.type === 'password') return; // Ne pas capturer les mots de passe
    
    const stepData = {
        type: 'input',
        element: {
            tagName: target.tagName.toLowerCase(),
            id: target.id,
            className: target.className,
            placeholder: target.placeholder,
            type: target.type
        },
        path: getElementPath(target),
        url: window.location.href,
        timestamp: new Date().toISOString()
    };
    
    stepData.description = generateDescription(stepData);
    
    chrome.runtime.sendMessage({
        type: 'CAPTURE_STEP',
        data: stepData
    });
}

// Gestionnaire de changement
function handleChange(event) {
    if (!shouldCaptureEvent(event)) return;
    
    const target = event.target;
    const stepData = {
        type: 'change',
        element: {
            tagName: target.tagName.toLowerCase(),
            id: target.id,
            className: target.className,
            value: target.type === 'password' ? '********' : target.value,
            type: target.type
        },
        path: getElementPath(target),
        url: window.location.href,
        timestamp: new Date().toISOString()
    };
    
    stepData.description = generateDescription(stepData);
    
    chrome.runtime.sendMessage({
        type: 'CAPTURE_STEP',
        data: stepData
    });
}

// Fonctions utilitaires

// Vérifier si un événement doit être capturé
function shouldCaptureEvent(event) {
    if (!config.isRecording || config.isPaused) return false;
    
    const target = event.target;
    if (!target || !target.tagName) return false;
    
    const tagName = target.tagName.toLowerCase();
    if (config.ignoredElements.includes(tagName)) return false;
    
    return true;
}

// Obtenir le chemin de l'élément dans le DOM
function getElementPath(element) {
    const path = [];
    let current = element;
    
    while (current && current !== document.body) {
        let selector = current.tagName.toLowerCase();
        
        if (current.id) {
            selector += `#${current.id}`;
        } else if (current.className) {
            selector += `.${current.className.split(' ').join('.')}`;
        }
        
        path.unshift(selector);
        current = current.parentElement;
    }
    
    return path.join(' > ');
}

// Générer une description automatique de l'action
function generateDescription(stepData) {
    const element = stepData.element;
    let description = '';
    
    switch (stepData.type) {
        case 'click':
            if (element.tagName === 'button' || element.tagName === 'a') {
                description = `Cliquer sur "${element.textContent || element.value || 'le bouton'}"`;
            } else if (element.tagName === 'input' && element.type === 'submit') {
                description = `Cliquer sur le bouton "${element.value || 'Envoyer'}"`;
            } else {
                description = `Cliquer sur l'élément ${element.tagName}`;
            }
            break;
            
        case 'input':
            description = `Saisir du texte dans le champ "${element.placeholder || element.id || 'de saisie'}"`;
            break;
            
        case 'change':
            if (element.tagName === 'select') {
                description = `Sélectionner une option dans la liste "${element.id || 'déroulante'}"`;
            } else if (element.type === 'checkbox') {
                description = `${element.checked ? 'Cocher' : 'Décocher'} la case "${element.id || ''}"`;
            } else if (element.type === 'radio') {
                description = `Sélectionner l'option "${element.value || ''}"`;
            }
            break;
    }
    
    return description;
}

// Fonction debounce pour limiter la fréquence des événements
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Fonction pour obtenir le chemin XPath d'un élément
function getXPath(element) {
    if (!element) return '';
    
    const idx = (sib, name) => sib 
        ? idx(sib.previousElementSibling, name||sib.localName) + (sib.localName == name)
        : 1;
    const segs = elm => !elm || elm.nodeType !== 1 
        ? ['']
        : elm.id && document.getElementById(elm.id) === elm
            ? [`id("${elm.id}")`]
            : [...segs(elm.parentNode), `${elm.localName.toLowerCase()}[${idx(elm)}]`];
    return segs(element).join('/');
}

// Fonction pour obtenir le sélecteur CSS d'un élément
function getCssSelector(element) {
    if (!element) return '';
    
    let path = [];
    while (element.nodeType === Node.ELEMENT_NODE) {
        let selector = element.nodeName.toLowerCase();
        if (element.id) {
            selector += '#' + element.id;
            path.unshift(selector);
            break;
        } else {
            let sibling = element;
            let nth = 1;
            while (sibling.previousElementSibling) {
                sibling = sibling.previousElementSibling;
                if (sibling.nodeName.toLowerCase() === selector)
                    nth++;
            }
            if (nth !== 1)
                selector += ":nth-of-type("+nth+")";
        }
        path.unshift(selector);
        element = element.parentNode;
    }
    return path.join(' > ');
}

// Gestionnaire de clics
document.addEventListener('click', function(event) {
    // Ne pas capturer les clics sur les éléments de l'extension
    if (event.target.closest('.hyperion-extension')) return;
    
    const stepData = {
        type: 'click',
        element: {
            tagName: event.target.tagName,
            className: event.target.className,
            id: event.target.id,
            text: event.target.textContent?.trim(),
            xpath: getXPath(event.target),
            cssSelector: getCssSelector(event.target)
        },
        position: {
            x: event.clientX,
            y: event.clientY,
            pageX: event.pageX,
            pageY: event.pageY
        },
        url: window.location.href,
        timestamp: new Date().toISOString()
    };
    
    // Envoyer les données au background script
    chrome.runtime.sendMessage({
        type: 'CAPTURE_STEP',
        data: stepData
    });
}, true);

// Indiquer que le script est chargé
chrome.runtime.sendMessage({
    type: 'CAPTURE_SCRIPT_LOADED',
    data: { url: window.location.href }
});

// Initialiser la capture
initialize(); 