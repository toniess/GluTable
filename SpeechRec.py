import speech_recognition as sr

record = sr.Recognizer()
microphone = sr.Microphone()
while True:
        try:
                with microphone as source:
                        record.adjust_for_ambient_noise(source)
                        audio = record.listen(source)
                        result = record.recognize_google(audio, language="ru-RU")
                        result = result.lower()
                        print(format(result))
        except sr.UnknownValueError:
                print("Ошибка")



