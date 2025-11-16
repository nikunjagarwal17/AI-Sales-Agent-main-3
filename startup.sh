#!/bin/bash
echo "Preparing vector database..."
python create_catalog.py
echo "Vector database ready. Starting Streamlit app..."
python -m streamlit run app.py --server.port=8000 --server.address=0.0.0.0
