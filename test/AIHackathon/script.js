// --- Drag and Drop Handlers ---
const dropZone = document.getElementById('drop-zone');

['dragenter', 'dragover'].forEach(eventName => {
  dropZone.addEventListener(eventName, (e) => {
    e.preventDefault();
    dropZone.classList.add('dragover');
  }, false);
});

['dragleave', 'drop'].forEach(eventName => {
  dropZone.addEventListener(eventName, (e) => {
    e.preventDefault();
    dropZone.classList.remove('dragover');
  }, false);
});

dropZone.addEventListener('drop', (e) => {
  const files = e.dataTransfer.files;
  if (files.length > 0) {
    uploadFile(files[0]);
  }
});

function handleFileSelect(event) {
  const files = event.target.files;
  if (files.length > 0) {
    uploadFile(files[0]);
  }
}

// --- API 1: Upload File & Trigger LLM Pipeline ---
function uploadFile(file) {
  showLoading(true);

  // Render local preview on left side
  renderDocumentPreview(file);

  const formData = new FormData();
  formData.append('file', file);

  fetch('/api/upload', {
    method: 'POST',
    body: formData
  })
  .then(response => {
    if (!response.ok) throw new Error('Extraction API failed');
    return response.json();
  })
  .then(data => {
    populateFormFields(data);
    document.querySelector('.upload-container').style.display = 'none';
    document.getElementById('comparison-section').style.display = 'grid';
  })
  .catch(error => {
    alert('Error processing document: ' + error.message);
  })
  .finally(() => {
    showLoading(false);
  });
}

// --- Render File Preview ---
function renderDocumentPreview(file) {
  const previewBox = document.getElementById('preview-box');
  previewBox.innerHTML = '';

  const fileURL = URL.createObjectURL(file);

  if (file.type.startsWith('image/')) {
    const img = document.createElement('img');
    img.src = fileURL;
    previewBox.appendChild(img);
  } else if (file.type === 'application/pdf') {
    const iframe = document.createElement('iframe');
    iframe.src = fileURL;
    previewBox.appendChild(iframe);
  } else {
    previewBox.innerHTML = `<div style="text-align:center; padding: 20px;">
      <p><strong>${file.name}</strong></p>
      <p style="color: var(--text-muted); margin-top:8px;">Preview unavailable for this format. Field extraction is ready on the right.</p>
    </div>`;
  }
}

// --- Populate Form Fields ---
function populateFormFields(data) {
  document.getElementById('field-report_id').value = data.report_id || '';
  document.getElementById('field-property_description').value = data.property_description || '';
  document.getElementById('field-appraised_value').value = data.appraised_value || '';
  document.getElementById('field-valuation_date').value = data.valuation_date || '';
  document.getElementById('field-valuation_method').value = data.valuation_method || '';
  document.getElementById('field-capitalization_rate').value = data.capitalization_rate || 0;

  const comps = Array.isArray(data.comparable_sales_references) 
    ? data.comparable_sales_references.join(', ') 
    : (data.comparable_sales_references || '');
  document.getElementById('field-comparable_sales_references').value = comps;
}

// --- API 2: Save / Commit Extracted Record ---
function commitExtractedData() {
  const compsRaw = document.getElementById('field-comparable_sales_references').value;
  const compsArray = compsRaw.split(',').map(item => item.trim()).filter(item => item.length > 0);

  const payload = {
    report_id: document.getElementById('field-report_id').value,
    property_description: document.getElementById('field-property_description').value,
    appraised_value: parseFloat(document.getElementById('field-appraised_value').value),
    valuation_date: document.getElementById('field-valuation_date').value,
    valuation_method: document.getElementById('field-valuation_method').value,
    capitalization_rate: parseFloat(document.getElementById('field-capitalization_rate').value),
    comparable_sales_references: compsArray
  };

  showLoading(true);

  fetch('/api/commit', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  })
  .then(response => {
    if (!response.ok) throw new Error('Commit failed');
    return response.json();
  })
  .then(result => {
    alert('Record committed successfully to database!');
  })
  .catch(error => {
    alert('Error committing record: ' + error.message);
  })
  .finally(() => {
    showLoading(false);
  });
}

// --- API 3: Fetch Historical Records ---
function fetchHistory() {
  showLoading(true);

  fetch('/api/history')
  .then(response => response.json())
  .then(data => {
    const tbody = document.getElementById('history-table-body');
    tbody.innerHTML = '';

    if (data.length === 0) {
      tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;">No records found.</td></tr>';
      return;
    }

    data.forEach(item => {
      const comps = Array.isArray(item.comparable_sales_references)
        ? item.comparable_sales_references.join(', ')
        : item.comparable_sales_references;

      const tr = document.createElement('tr');
      tr.innerHTML = `
        <td><strong>${item.report_id}</strong></td>
        <td>${item.property_description}</td>
        <td>$${item.appraised_value ? item.appraised_value.toLocaleString() : '0'}</td>
        <td>${item.valuation_date}</td>
        <td>${item.valuation_method}</td>
        <td>${item.capitalization_rate}%</td>
        <td>${comps}</td>
      `;
      tbody.appendChild(tr);
    });
  })
  .catch(error => {
    console.error('Error loading history:', error);
  })
  .finally(() => {
    showLoading(false);
  });
}

// --- Helper Functions ---
function showLoading(visible) {
  document.getElementById('loading-overlay').style.display = visible ? 'flex' : 'none';
}

function switchView(viewId) {
  document.querySelectorAll('.view-panel').forEach(panel => panel.classList.remove('active'));
  document.querySelectorAll('nav button').forEach(btn => btn.classList.remove('active'));

  document.getElementById(viewId).classList.add('active');

  if (viewId === 'upload-view') {
    document.getElementById('nav-upload-btn').classList.add('active');
  } else {
    document.getElementById('nav-history-btn').classList.add('active');
  }
}