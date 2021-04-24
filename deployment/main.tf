provider "google" {
  project = "" # add project name before deployment
  region = "europe-west3"
  zone = "europe-west3-a"
  credentials = "../service-acc-key.json" # not available on GitHub
}

resource "google_storage_bucket" "bucket" {
  name = "msuver-marcura-project"
}

resource "google_storage_bucket_object" "archive" {
  name = "project.zip"
  bucket = google_storage_bucket.bucket.name
  source = "project.zip"
}

resource "google_cloudfunctions_function" "function" {
  name = "marcura-task"
  runtime = "python38"

  available_memory_mb = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http = true
  timeout = 60
  entry_point = "main"
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  cloud_function = google_cloudfunctions_function.function.name
  role = "roles/cloudfunctions.invoker"
  member = "allUsers"
}