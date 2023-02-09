#!/bin/bash

api="https://api.anonuniverse.com"
user_id=null
access_token=null
country_code="RU"
device_id=$(cat /dev/urandom | tr -dc "a-z0-9" | fold -w 24 | head -n 1)

function generate_usernames() {
	curl --request POST \
		--url "$api/users/generate" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--data '[]'
}

function generate_login() {
	curl --request POST \
		--url "$api/auth/register/generate" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--data '{"name": "'$1'"}'
}

function login() {
	response=$(curl --request POST \
		--url "$api/auth/login" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--data '{
			"login": "'$1'",
			"password": "'$2'"
		}')
	if [ -n $(jq -r ".data.token" <<<"$response") ]; then
		user_id=$(jq -r ".data.id" <<<"$response")
		access_token=$(jq -r ".data.token" <<<"$response")
	fi
	echo $response
}


function register() {
	curl --request POST \
		--url "$api/auth/register" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--data '{
			"login": "'$1'",
			"name": "'$2'",
			"password": "'$3'"
		}'
}

function get_account_info() {
	curl --request GET \
		--url "$api/users/me" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_cards() {
	curl --request GET \
		--url "$api/users/cards" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_avatars() {
	curl --request GET \
		--url "$api/posts/assets/avatars" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD"
}

function get_awards() {
	curl --request GET \
		--url "$api/users/awards" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_versions() {
	curl --request GET \
		--url "$api/gateway/versions" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_notifications() {
	curl --request GET \
		--url "$api/notifications?first=$1" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_popular_posts() {
	url="$api/posts/v1/main?filter=TOP&first=$1&periodOfTime=$2&include=$3"
	if [ -n "$4" ]; then
		url+="&after=$4"
	fi
	curl --request GET \
		--url $url \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_newest_posts() {
	url="$api/posts/v1/main?filter=NEWEST&first=$1&periodOfTime=$2&include=$3"
	if [ -n "$4" ]; then
		url+="&after=$4"
	fi
	curl --request GET \
		--url $url \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_subs_posts() {
	url="$api/posts/v1/main?filter=MY_SUBSCRIPTIONS&first=$1&periodOfTime=$2&include=$3"
	if [ -n "$4" ]; then
		url+="&after=$4"
	fi
	curl --request GET \
		--url $url \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_popular_challenges() {
	curl --request GET \
		--url "$api/posts/v1/challenges?filter=POPULAR" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_new_challenges() {
	curl --request GET \
		--url "$api/posts/v1/challenges?filter=NEW" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_challenge_winners() {
	curl --request GET \
		--url "$api/posts/v1/challenges/posts?filter=WINNERS&first=$1" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_gifts() {
	curl --request GET \
		--url "$api/users/me/gifts" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_given_gifts() {
	curl --request GET \
		--url "$api/users/me/gifts/given" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_user_info() {
	curl --request GET \
		--url "$api/users/$1" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_user_posts() {
	curl --request GET \
		--url "$api/posts/v1/profiles/$1/posts?orderBy=$2&first=$3" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function follow_user() {
	curl --request POST \
		--url "$api/users/$1/subscription" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token" \
		--data '[]'
}

function unfollow_user() {
	curl --request DELETE \
		--url "$api/users/$1/subscription" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function block_user() {
	curl --request POST \
		--url "$api/users/$1/blacklist" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token" \
		--data '[]'
}

function unblock_user() {
	curl --request DELETE \
		--url "$api/users/$1/blacklist" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function report_user() {
	curl --request POST \
		--url "$api/users/$1/blacklist" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token" \
		-data '{
			"id": "'$1'",
			"reason": "'$2'",
			"type": "PROFILE"
		}'
}

function get_post_info() {
	curl --request GET \
		--url "$api/posts/v1/posts/$1" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function like_post() {
	curl --request POST \
		--url "$api/posts/v1/posts/$1/likes" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token" \
		--data '[]'
}

function unlike_user() {
	curl --request DELETE \
		--url "$api/posts/v1/posts/$1/likes" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function view_post() {
	curl --request POST \
		--url "$api/posts/v1/posts/$1/views" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token" \
		--data '[]'
}

function get_post_comments() {
	curl --request GET \
		--url "$api/posts/v1/posts/$1/comments?first=$2" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}


function like_comment() {
	curl --request POST \
		--url "$api/posts/v1/comments/$1/likes" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token" \
		--data '[]'
}

function unlike_comment() {
	curl --request DELETE \
		--url "$api/posts/v1/comments/$1/likes" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function delete_comment() {
	curl --request DELETE \
		--url "$api/posts/v1/comments/$1?blockAuthor=$2&onlyForMe=$3" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function restore_comment() {
	curl --request POST \
		--url "$api/posts/v1/comments/$1/restore?unlockAuthor=$2" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function send_chat_request() {
	curl --request POST \
		--url "$api/users/$1/chat-request" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token" \
		--data '{
			"greeting": "'$2'"
		}'
}

function get_stories() {
	curl --request GET \
		--url "$api/posts/v1/stories?first=$1" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_assets() {
	curl --request GET \
		--url "$api/posts/assets" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function change_password() {
	curl --request POST \
		--url "$api/auth/password" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token" \
		--data '{
			"oldPassword": "'$1'",
			"newPassword": "'$2'"
		}'
}

function get_blocked_users() {
	curl --request GET \
		--url "$api/users/me/blacklist" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function report_post() {
	curl --request POST \
		--url "$api/users/complaints" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token" \
		-data '{
			"id": "'$1'",
			"reason": "'$2'",
			"type": "POST"
		}'
}

function read_notifications() {
	curl --request POST \
		--url "$api/notifications/mark-as-read" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token" \
		--data '{}'
}

function get_account_comments() {
	curl --request GET \
		--url "$api/posts/v1/comments/me?first=$1&filter=$2" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_deletion_reasons() {
	curl --request GET \
		--url "$api/auth/destroy/list" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function get_chat_requests() {
	curl --request GET \
		--url "$api/users/feed/chat-requests" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token"
}

function delete_account() {
	curl --request POST \
		--url "$api/auth/destroy" \
		--user-agent "okhttp/4.9.1" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-android-lite: 3.23.0.1228" \
		--header "x-country-code: $country_code" \
		--header "x-device-id: $device_id" \
		--header "x-device-model: Asus ASUS_Z01QD" \
		--header "authorization: $access_token" \
		--data '{
			"reason": "'$1'"
		}'
}
