import * as vscode from 'vscode';
import { getHelpContent } from './help-content';

export async function activate(context: vscode.ExtensionContext) {
  context.subscriptions.push(
    vscode.commands.registerCommand('drupalpod-ext.start', () => {
      const panel = vscode.window.createWebviewPanel(
        'drupalpod-ext',
        'Contribution Guide',
        vscode.ViewColumn.One,
        {}
      );

      panel.webview.html = getHelpContent();
    })
  );

  const config = vscode.workspace.getConfiguration('drupalpod');
  if (!config.has('hideOnStartup') || !config.get('hideOnStartup')) {
    await vscode.commands.executeCommand('drupalpod-ext.start');
  }
}

// this method is called when your extension is deactivated
export function deactivate() {}
