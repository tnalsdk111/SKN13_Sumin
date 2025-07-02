##################################################################
# streamlit/03_LLM.py
# 챗봇 대화 관련 위젯 튜토리얼
##################################################################
import streamlit as st
import random
from dotenv import load_dotenv
import os
from openai import OpenAI

# 환경 변수 로딩 (API 키 등)
load_dotenv()  
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# 타이틀
st.title("수민공듀가 불러옴")

# 1. 세션 상태에 messages 키가 없다면 빈 리스트로 초기화
if "messages" not in st.session_state:
    st.session_state["messages"] = []

# 2. 사용자 입력 받기
prompt = st.chat_input("나 짱이지")

# 3. 사용자 입력이 있을 경우 처리
if prompt:
    # (1) 사용자 메시지 저장
    st.session_state["messages"].append({"role": "user", "content": prompt})

    # (2) GPT 모델에게 응답 요청
    response = client.chat.completions.create(
        model="gpt-4o-mini",  # 사용 가능한 모델명 (gpt-3.5-turbo, gpt-4, gpt-4o 등)
        messages=st.session_state["messages"]
    )

    # (3) GPT 응답 메시지 추출 및 저장
    ai_message = response.choices[0].message.content
    st.session_state["messages"].append({"role": "assistant", "content": ai_message})

# 4. 대화 이력 출력
for message_dict in st.session_state["messages"]:
    with st.chat_message(message_dict["role"]):
        st.write(message_dict["content"])
