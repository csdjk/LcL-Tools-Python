
from openai import OpenAI

client = OpenAI(api_key="sk-cb4cf29d999044429abb234bd2224e7b", base_url="https://api.deepseek.com")

response = client.chat.completions.create(
    model="deepseek-chat",
    messages=[
        {"role": "system", "content": "You are a helpful assistant"},
        {"role": "user", "content": "Hello"},
    ],
    stream=False
)

print("Deepseek测试")
print(response.choices[0].message.content)

