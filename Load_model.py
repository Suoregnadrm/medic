import tensorflow as tf
import numpy as np
import pandas as pd
import string
import spacy
import string
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from tensorflow.keras.preprocessing.text import Tokenizer
import tensorflow as tf
from tensorflow.keras.preprocessing.sequence import pad_sequences
from keras.layers import Layer
import keras.backend as K

class attention(Layer):
    def __init__(self, **kwargs):
        super(attention, self).__init__(**kwargs)
        
    def build(self, input_shape):
        self.weight = self.add_weight(name="att_weight", shape=(input_shape[-1], 1), initializer='normal')
        self.bias = self.add_weight(name="att_bias", shape=(input_shape[1], 1))
        super(attention, self).build(input_shape)
        
    def call(self, x):
        ffn = K.squeeze(K.tanh(K.dot(x, self.weight) + self.bias), axis=-1)
        att = K.softmax(ffn)
        att=K.expand_dims(att,axis=-1)
        output = x*att
        return K.sum(output,axis=1)
    
    def compute_output_shape(self,input_shape):
            return (input_shape[0],input_shape[-1])
        
    def get_config(self):
        return super(attention,self).get_config()

class model_class:
	def __init__(self):
		self.model1 = tf.keras.models.load_model('LSTM_76.model')
		self.model2 = tf.keras.models.load_model('LSTM_ED_81.model')
		self.model3 = tf.keras.models.load_model('LSTM_ATT_85.model', custom_objects={'attention': attention})

	def prediction1(self, sentence):
		sentence = sentence.lower()
		whitespace_removed = remove_whitespace(sentence)
		lemmatized = lemmatization(whitespace_removed)
		x = tokenizer.texts_to_sequences([lemmatized])
		padded_test = pad_sequences(x, padding='post')

		pred1 = np.argmax(self.model1.predict(padded_test.reshape(1,-1)))
		print(list(le.inverse_transform([pred1])))
		pr1 = list(le.inverse_transform([pred1]))
		return pr1 

	def prediction2(self, sentence):
		sentence = sentence.lower()
		whitespace_removed = remove_whitespace(sentence)
		lemmatized = lemmatization(whitespace_removed)
		x = tokenizer.texts_to_sequences([lemmatized])
		padded_test = pad_sequences(x, padding='post')

		pred2 = np.argmax(self.model2.predict(padded_test.reshape(1,-1)))
		print(list(le.inverse_transform([pred2])))
		pr2 = list(le.inverse_transform([pred2]))
		return pr2

	def prediction3(self, sentence):
		sentence = sentence.lower()
		whitespace_removed = remove_whitespace(sentence)
		lemmatized = lemmatization(whitespace_removed)
		x = tokenizer.texts_to_sequences([lemmatized])
		padded_test = pad_sequences(x, maxlen=25, padding='post')

		pred3 = np.argmax(self.model3.predict(padded_test.reshape(1,-1)))
		print(list(le.inverse_transform([pred3])))
		pr3 = list(le.inverse_transform([pred3]))
		return pr3


data = pd.read_csv("Dataset.csv")
data = data.drop("Unnamed: 0", axis=1)

le = LabelEncoder()
labels = le.fit_transform(data['label'])
labels = labels.astype('int64')

corpus = data['text']
corpus = corpus.str.lower()

def remove_whitespace(x):
    if x[0] == " ":
        x = x[1:]
    if x[-1] == " ":
        x = x[:-1]
    
    return x
whitespace_removed = corpus.apply(lambda x: remove_whitespace(x))

spacy_model = spacy.load("en_core_web_sm")
punctuations = string.punctuation

def lemmatization(x):
    doc = spacy_model(x)
    text = ""
    for i in doc:
        if (i.is_stop == False) and (i.lemma_ not in punctuations):
            text += " "+i.lemma_
    return text[1:]

lemmatized = whitespace_removed.apply(lambda x: lemmatization(x))

tokenizer = Tokenizer(num_words=1500, oov_token='<UNK>')
tokenizer.fit_on_texts(lemmatized)