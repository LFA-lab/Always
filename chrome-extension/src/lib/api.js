const API_BASE_URL = 'https://always-mvp.herokuapp.com/api';

export const saveGuide = async (guide) => {
  try {
    const response = await fetch(`${API_BASE_URL}/guides`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ guide }),
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    console.error('Error saving guide:', error);
    throw error;
  }
};

export const loadGuides = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/guides`);
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    console.error('Error loading guides:', error);
    throw error;
  }
}; 