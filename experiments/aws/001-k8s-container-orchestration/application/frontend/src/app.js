// Application state
let backendUrl = '/api';

// Initialize the application
document.addEventListener('DOMContentLoaded', function() {
    updateTimestamp();
    checkBackendStatus();
    
    // Update timestamp every second
    setInterval(updateTimestamp, 1000);
    
    // Check backend status every 30 seconds
    setInterval(checkBackendStatus, 30000);
});

// Update timestamp display
function updateTimestamp() {
    const now = new Date();
    const timestamp = now.toLocaleString('ja-JP', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });
    document.getElementById('timestamp').textContent = timestamp;
}

// Check backend API status
async function checkBackendStatus() {
    const statusElement = document.getElementById('backend-status');
    
    try {
        statusElement.textContent = '🟡 確認中...';
        statusElement.className = 'status-indicator loading';
        
        const response = await fetch(`${backendUrl}/health`);
        
        if (response.ok) {
            statusElement.textContent = '🟢 Running';
            statusElement.className = 'status-indicator success';
        } else {
            throw new Error(`HTTP ${response.status}`);
        }
    } catch (error) {
        statusElement.textContent = '🔴 Disconnected';
        statusElement.className = 'status-indicator error';
        console.error('Backend health check failed:', error);
    }
}

// API test functions
async function testHealthCheck() {
    const outputElement = document.getElementById('api-output');
    outputElement.textContent = 'ヘルスチェック実行中...';
    
    try {
        const response = await fetch(`${backendUrl}/health`);
        const data = await response.json();
        
        const result = {
            status: response.status,
            statusText: response.statusText,
            data: data,
            timestamp: new Date().toISOString()
        };
        
        outputElement.textContent = JSON.stringify(result, null, 2);
    } catch (error) {
        const result = {
            error: error.message,
            timestamp: new Date().toISOString()
        };
        outputElement.textContent = JSON.stringify(result, null, 2);
    }
}

async function testUserAPI() {
    const outputElement = document.getElementById('api-output');
    outputElement.textContent = 'ユーザーAPI実行中...';
    
    try {
        const response = await fetch(`${backendUrl}/users`);
        const data = await response.json();
        
        const result = {
            status: response.status,
            statusText: response.statusText,
            data: data,
            timestamp: new Date().toISOString()
        };
        
        outputElement.textContent = JSON.stringify(result, null, 2);
    } catch (error) {
        const result = {
            error: error.message,
            timestamp: new Date().toISOString()
        };
        outputElement.textContent = JSON.stringify(result, null, 2);
    }
}

async function testMetrics() {
    const outputElement = document.getElementById('api-output');
    outputElement.textContent = 'メトリクス取得中...';
    
    try {
        const response = await fetch(`${backendUrl}/metrics`);
        const data = await response.json();
        
        const result = {
            status: response.status,
            statusText: response.statusText,
            data: data,
            timestamp: new Date().toISOString()
        };
        
        outputElement.textContent = JSON.stringify(result, null, 2);
    } catch (error) {
        const result = {
            error: error.message,
            timestamp: new Date().toISOString()
        };
        outputElement.textContent = JSON.stringify(result, null, 2);
    }
}

// Utility function to generate container ID
function generateContainerID() {
    const hostname = window.location.hostname;
    const random = Math.random().toString(36).substring(2, 8);
    return `frontend-${hostname}-${random}`;
}

// Set container ID on load
document.addEventListener('DOMContentLoaded', function() {
    const containerIdElement = document.getElementById('container-id');
    if (containerIdElement) {
        containerIdElement.textContent = generateContainerID();
    }
});