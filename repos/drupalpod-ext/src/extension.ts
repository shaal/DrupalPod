import * as vscode from 'vscode';

export async function activate(context: vscode.ExtensionContext) {
  context.subscriptions.push(
    vscode.commands.registerCommand('drupalpod-ext.start', () => {
      const panel = vscode.window.createWebviewPanel(
        'drupalpod-ext',
        'Contribution Guide',
        vscode.ViewColumn.One,
        {}
      );
    })
  );

  if (!vscode.workspace.getConfiguration('drupalpod.hideOnStartup')) {
    await vscode.commands.executeCommand('drupalpod-ext.start');
  }
}

// this method is called when your extension is deactivated
export function deactivate() {}
