use tauri::{AppHandle, Manager, WebviewWindowBuilder, WebviewUrl, Emitter};
use uuid::Uuid;

#[tauri::command]
pub async fn spawn_new_instance(app: AppHandle, project_path: Option<String>) -> Result<String, String> {
    let window_label = format!("claudia-{}", Uuid::new_v4().to_string());
    
    let window = WebviewWindowBuilder::new(
        &app,
        &window_label,
        WebviewUrl::App("index.html".into())
    )
    .title("Claudia II")
    .inner_size(1200.0, 800.0)
    .theme(Some(tauri::Theme::Dark))
    .build()
    .map_err(|e| format!("Failed to create new window: {}", e))?;
    
    // If project path is specified, emit it to the new window
    if let Some(path) = project_path {
        window.emit("initial_project_path", &path).ok();
    }
    
    Ok(window_label)
}

#[tauri::command]
pub async fn list_windows(app: AppHandle) -> Result<Vec<String>, String> {
    let windows = app.webview_windows();
    let window_labels: Vec<String> = windows.keys().cloned().collect();
    Ok(window_labels)
}

#[tauri::command]
pub async fn focus_window(app: AppHandle, window_label: String) -> Result<(), String> {
    if let Some(window) = app.get_webview_window(&window_label) {
        window.set_focus().map_err(|e| format!("Failed to focus window: {}", e))?;
        Ok(())
    } else {
        Err("Window not found".to_string())
    }
}

#[tauri::command]
pub async fn close_window(app: AppHandle, window_label: String) -> Result<(), String> {
    if let Some(window) = app.get_webview_window(&window_label) {
        window.close().map_err(|e| format!("Failed to close window: {}", e))?;
        Ok(())
    } else {
        Err("Window not found".to_string())
    }
}

#[tauri::command]
pub async fn get_current_window_label(app: AppHandle) -> Result<String, String> {
    // Get the focused window or the main window
    let windows = app.webview_windows();
    if let Some((label, _)) = windows.iter().next() {
        Ok(label.clone())
    } else {
        Err("No windows found".to_string())
    }
}