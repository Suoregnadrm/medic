from flask import Flask, request, jsonify
from Load_model import model_class
from collections import Counter
import pandas as pd

app = Flask(__name__)
model = model_class()
desc = pd.read_csv("Dataset2.csv")
desc['Disease'] = desc['Disease'].str.lower()

@app.route('/', methods=['GET', 'POST'])
def predict():
    if request.method == 'POST':
        try:
            sentence = request.form['sentence']
            prediction1 = model.prediction1(sentence)
            prediction2 = model.prediction2(sentence)
            prediction3 = model.prediction3(sentence)

            counts = Counter(prediction1+prediction2+prediction3)
            m, count = counts.most_common(1)[0]

            description = ''
            speciality = ''
            Precaution1 = ''
            Precaution2 = ''
            Precaution3 = ''
            Precaution4 = ''
            max_c = ''

            if(count>1):
            	idx_of_disease = desc['Disease'].tolist().index(m.lower())
            	description = desc['Description'][idx_of_disease]
            	speciality = desc['Speciality'][idx_of_disease]
            	Precaution1 = desc['Precaution_1'][idx_of_disease]
            	Precaution2 = desc['Precaution_2'][idx_of_disease]
            	Precaution3 = desc['Precaution_3'][idx_of_disease]
            	Precaution4 = desc['Precaution_4'][idx_of_disease]
            	max_c = m

            return jsonify({'prediction': prediction1[0], 'prediction2': prediction2[0], 'prediction3': prediction3[0], 'description': description, 'speciality':speciality, 'precaution1':Precaution1, 'precaution2':Precaution2,'precaution3':Precaution3, 'precaution4':Precaution4, 'max_c':max_c})

        except Exception as e:
            return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000, use_reloader=False)